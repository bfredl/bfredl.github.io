/*
 * Wait "msec" msec until a character is available from file descriptor "fd".
 * "msec" == 0 will check for characters once.
 * "msec" == -1 will block until a character is available.
 * When a GUI is being used, this will not be used for input -- webb
 * Returns also, when a request from Sniff is waiting -- toni.
 * Or when a Linux GPM mouse event is waiting.
 */
#if defined(__BEOS__)
    int
#else
    static  int
#endif
RealWaitForChar(fd, msec, check_for_gpm)
    int		fd;
    long	msec;
    int		*check_for_gpm UNUSED;
{
    int		ret;
#ifdef FEAT_NETBEANS_INTG
    int		nb_fd = netbeans_filedesc();
#endif
#if defined(FEAT_XCLIPBOARD) || defined(USE_XSMP) || defined(FEAT_MZSCHEME)
    static int	busy = FALSE;

    /* May retry getting characters after an event was handled. */
# define MAY_LOOP

# if defined(HAVE_GETTIMEOFDAY) && defined(HAVE_SYS_TIME_H)
    /* Remember at what time we started, so that we know how much longer we
     * should wait after being interrupted. */
#  define USE_START_TV
    struct timeval  start_tv;

    if (msec > 0 && (
#  ifdef FEAT_XCLIPBOARD
	    xterm_Shell != (Widget)0
#   if defined(USE_XSMP) || defined(FEAT_MZSCHEME)
	    ||
#   endif
#  endif
#  ifdef USE_XSMP
	    xsmp_icefd != -1
#   ifdef FEAT_MZSCHEME
	    ||
#   endif
#  endif
#  ifdef FEAT_MZSCHEME
	(mzthreads_allowed() && p_mzq > 0)
#  endif
	    ))
	gettimeofday(&start_tv, NULL);
# endif

    /* Handle being called recursively.  This may happen for the session
     * manager stuff, it may save the file, which does a breakcheck. */
    if (busy)
	return 0;
#endif

#ifdef MAY_LOOP
    for (;;)
#endif
    {
#ifdef MAY_LOOP
	int		finished = TRUE; /* default is to 'loop' just once */
# ifdef FEAT_MZSCHEME
	int		mzquantum_used = FALSE;
# endif
#endif
#ifndef HAVE_SELECT
	struct pollfd   fds[6];
	int		nfd;
# ifdef FEAT_XCLIPBOARD
	int		xterm_idx = -1;
# endif
# ifdef FEAT_MOUSE_GPM
	int		gpm_idx = -1;
# endif
# ifdef USE_XSMP
	int		xsmp_idx = -1;
# endif
# ifdef FEAT_NETBEANS_INTG
	int		nb_idx = -1;
# endif
	int		towait = (int)msec;

# ifdef FEAT_MZSCHEME
	mzvim_check_threads();
	if (mzthreads_allowed() && p_mzq > 0 && (msec < 0 || msec > p_mzq))
	{
	    towait = (int)p_mzq;    /* don't wait longer than 'mzquantum' */
	    mzquantum_used = TRUE;
	}
# endif
	fds[0].fd = fd;
	fds[0].events = POLLIN;
	nfd = 1;

# ifdef FEAT_SNIFF
#  define SNIFF_IDX 1
	if (want_sniff_request)
	{
	    fds[SNIFF_IDX].fd = fd_from_sniff;
	    fds[SNIFF_IDX].events = POLLIN;
	    nfd++;
	}
# endif
# ifdef FEAT_XCLIPBOARD
	if (xterm_Shell != (Widget)0)
	{
	    xterm_idx = nfd;
	    fds[nfd].fd = ConnectionNumber(xterm_dpy);
	    fds[nfd].events = POLLIN;
	    nfd++;
	}
# endif
# ifdef FEAT_MOUSE_GPM
	if (check_for_gpm != NULL && gpm_flag && gpm_fd >= 0)
	{
	    gpm_idx = nfd;
	    fds[nfd].fd = gpm_fd;
	    fds[nfd].events = POLLIN;
	    nfd++;
	}
# endif
# ifdef USE_XSMP
	if (xsmp_icefd != -1)
	{
	    xsmp_idx = nfd;
	    fds[nfd].fd = xsmp_icefd;
	    fds[nfd].events = POLLIN;
	    nfd++;
	}
# endif
#ifdef FEAT_NETBEANS_INTG
	if (nb_fd != -1)
	{
	    nb_idx = nfd;
	    fds[nfd].fd = nb_fd;
	    fds[nfd].events = POLLIN;
	    nfd++;
	}
#endif

	ret = poll(fds, nfd, towait);
# ifdef FEAT_MZSCHEME
	if (ret == 0 && mzquantum_used)
	    /* MzThreads scheduling is required and timeout occurred */
	    finished = FALSE;
# endif

# ifdef FEAT_SNIFF
	if (ret < 0)
	    sniff_disconnect(1);
	else if (want_sniff_request)
	{
	    if (fds[SNIFF_IDX].revents & POLLHUP)
		sniff_disconnect(1);
	    if (fds[SNIFF_IDX].revents & POLLIN)
		sniff_request_waiting = 1;
	}
# endif
# ifdef FEAT_XCLIPBOARD
	if (xterm_Shell != (Widget)0 && (fds[xterm_idx].revents & POLLIN))
	{
	    xterm_update();      /* Maybe we should hand out clipboard */
	    if (--ret == 0 && !input_available())
		/* Try again */
		finished = FALSE;
	}
# endif
# ifdef FEAT_MOUSE_GPM
	if (gpm_idx >= 0 && (fds[gpm_idx].revents & POLLIN))
	{
	    *check_for_gpm = 1;
	}
# endif
# ifdef USE_XSMP
	if (xsmp_idx >= 0 && (fds[xsmp_idx].revents & (POLLIN | POLLHUP)))
	{
	    if (fds[xsmp_idx].revents & POLLIN)
	    {
		busy = TRUE;
		xsmp_handle_requests();
		busy = FALSE;
	    }
	    else if (fds[xsmp_idx].revents & POLLHUP)
	    {
		if (p_verbose > 0)
		    verb_msg((char_u *)_("XSMP lost ICE connection"));
		xsmp_close();
	    }
	    if (--ret == 0)
		finished = FALSE;	/* Try again */
	}
# endif
#ifdef FEAT_NETBEANS_INTG
	if (ret > 0 && nb_idx != -1 && fds[nb_idx].revents & POLLIN)
	{
	    netbeans_read();
	    --ret;
	}
#endif


#else /* HAVE_SELECT */

	struct timeval  tv;
	struct timeval	*tvp;
	fd_set		rfds, efds;
	int		maxfd;
	long		towait = msec;

# ifdef FEAT_MZSCHEME
	mzvim_check_threads();
	if (mzthreads_allowed() && p_mzq > 0 && (msec < 0 || msec > p_mzq))
	{
	    towait = p_mzq;	/* don't wait longer than 'mzquantum' */
	    mzquantum_used = TRUE;
	}
# endif
# ifdef __EMX__
	/* don't check for incoming chars if not in raw mode, because select()
	 * always returns TRUE then (in some version of emx.dll) */
	if (curr_tmode != TMODE_RAW)
	    return 0;
# endif

	if (towait >= 0)
	{
	    tv.tv_sec = towait / 1000;
	    tv.tv_usec = (towait % 1000) * (1000000/1000);
	    tvp = &tv;
	}
	else
	    tvp = NULL;

	/*
	 * Select on ready for reading and exceptional condition (end of file).
	 */
select_eintr:
	FD_ZERO(&rfds);
	FD_ZERO(&efds);
	FD_SET(fd, &rfds);
# if !defined(__QNX__) && !defined(__CYGWIN32__)
	/* For QNX select() always returns 1 if this is set.  Why? */
	FD_SET(fd, &efds);
# endif
	maxfd = fd;

# ifdef FEAT_SNIFF
	if (want_sniff_request)
	{
	    FD_SET(fd_from_sniff, &rfds);
	    FD_SET(fd_from_sniff, &efds);
	    if (maxfd < fd_from_sniff)
		maxfd = fd_from_sniff;
	}
# endif
# ifdef FEAT_XCLIPBOARD
	if (xterm_Shell != (Widget)0)
	{
	    FD_SET(ConnectionNumber(xterm_dpy), &rfds);
	    if (maxfd < ConnectionNumber(xterm_dpy))
		maxfd = ConnectionNumber(xterm_dpy);

	    /* An event may have already been read but not handled.  In
	     * particulary, XFlush may cause this. */
	    xterm_update();
	}
# endif
# ifdef FEAT_MOUSE_GPM
	if (check_for_gpm != NULL && gpm_flag && gpm_fd >= 0)
	{
	    FD_SET(gpm_fd, &rfds);
	    FD_SET(gpm_fd, &efds);
	    if (maxfd < gpm_fd)
		maxfd = gpm_fd;
	}
# endif
# ifdef USE_XSMP
	if (xsmp_icefd != -1)
	{
	    FD_SET(xsmp_icefd, &rfds);
	    FD_SET(xsmp_icefd, &efds);
	    if (maxfd < xsmp_icefd)
		maxfd = xsmp_icefd;
	}
# endif
# ifdef FEAT_NETBEANS_INTG
	if (nb_fd != -1)
	{
	    FD_SET(nb_fd, &rfds);
	    if (maxfd < nb_fd)
		maxfd = nb_fd;
	}
# endif

	ret = select(maxfd + 1, &rfds, NULL, &efds, tvp);
# ifdef EINTR
	if (ret == -1 && errno == EINTR)
	{
	    /* Check whether window has been resized, EINTR may be caused by
	     * SIGWINCH. */
	    if (do_resize)
		handle_resize();

	    /* Interrupted by a signal, need to try again.  We ignore msec
	     * here, because we do want to check even after a timeout if
	     * characters are available.  Needed for reading output of an
	     * external command after the process has finished. */
	    goto select_eintr;
	}
# endif
# ifdef __TANDEM
	if (ret == -1 && errno == ENOTSUP)
	{
	    FD_ZERO(&rfds);
	    FD_ZERO(&efds);
	    ret = 0;
	}
# endif
# ifdef FEAT_MZSCHEME
	if (ret == 0 && mzquantum_used)
	    /* loop if MzThreads must be scheduled and timeout occurred */
	    finished = FALSE;
# endif

# ifdef FEAT_SNIFF
	if (ret < 0 )
	    sniff_disconnect(1);
	else if (ret > 0 && want_sniff_request)
	{
	    if (FD_ISSET(fd_from_sniff, &efds))
		sniff_disconnect(1);
	    if (FD_ISSET(fd_from_sniff, &rfds))
		sniff_request_waiting = 1;
	}
# endif
# ifdef FEAT_XCLIPBOARD
	if (ret > 0 && xterm_Shell != (Widget)0
		&& FD_ISSET(ConnectionNumber(xterm_dpy), &rfds))
	{
	    xterm_update();	      /* Maybe we should hand out clipboard */
	    /* continue looping when we only got the X event and the input
	     * buffer is empty */
	    if (--ret == 0 && !input_available())
	    {
		/* Try again */
		finished = FALSE;
	    }
	}
# endif
# ifdef FEAT_MOUSE_GPM
	if (ret > 0 && gpm_flag && check_for_gpm != NULL && gpm_fd >= 0)
	{
	    if (FD_ISSET(gpm_fd, &efds))
		gpm_close();
	    else if (FD_ISSET(gpm_fd, &rfds))
		*check_for_gpm = 1;
	}
# endif
# ifdef USE_XSMP
	if (ret > 0 && xsmp_icefd != -1)
	{
	    if (FD_ISSET(xsmp_icefd, &efds))
	    {
		if (p_verbose > 0)
		    verb_msg((char_u *)_("XSMP lost ICE connection"));
		xsmp_close();
		if (--ret == 0)
		    finished = FALSE;   /* keep going if event was only one */
	    }
	    else if (FD_ISSET(xsmp_icefd, &rfds))
	    {
		busy = TRUE;
		xsmp_handle_requests();
		busy = FALSE;
		if (--ret == 0)
		    finished = FALSE;   /* keep going if event was only one */
	    }
	}
# endif
#ifdef FEAT_NETBEANS_INTG
	if (ret > 0 && nb_fd != -1 && FD_ISSET(nb_fd, &rfds))
	{
	    netbeans_read();
	    --ret;
	}
#endif

#endif /* HAVE_SELECT */

#ifdef MAY_LOOP
	if (finished || msec == 0)
	    break;

	/* We're going to loop around again, find out for how long */
	if (msec > 0)
	{
# ifdef USE_START_TV
	    struct timeval  mtv;

	    /* Compute remaining wait time. */
	    gettimeofday(&mtv, NULL);
	    msec -= (mtv.tv_sec - start_tv.tv_sec) * 1000L
				   + (mtv.tv_usec - start_tv.tv_usec) / 1000L;
# else
	    /* Guess we got interrupted halfway. */
	    msec = msec / 2;
# endif
	    if (msec <= 0)
		break;	/* waited long enough */
	}
#endif
    }

    return (ret > 0);

}
