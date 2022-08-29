commit 7f9969c559b51446632ac7e8f76cde07e7d0078d (tag: v9.0.0067)
Date:   Mon Jul 25 18:13:54 2022 +0100

    patch 9.0.0067: cannot show virtual text

    Problem:    Cannot show virtual text.
    Solution:   Initial changes for virtual text support, using text properties.

introduces `chartabsize_T` and `init_chartabsize_arg()`
used in many places like `edit.c` . affects virtual editing or no? (like `ins_tab()` to next tab vcol)

commit 711483cd1381a4ed848d783ae0a6792d5b04447b (tag: v9.0.0116)
Date:   Sat Jul 30 21:33:46 2022 +0100

    patch 9.0.0116: virtual text not displayed if 'signcolumn' is "yes"
    
    Problem:    Virtual text not displayed if 'signcolumn' is "yes".
    Solution:   Set c_extra and c_final to NUL.

commit b7963df98f9dbbb824713acad2f47c9989fcf8f3 (tag: v9.0.0121)
Date:   Sun Jul 31 17:12:43 2022 +0100

    patch 9.0.0121: cannot put virtual text after or below a line
    
    Problem:    Cannot put virtual text after or below a line.
    Solution:   Add "text_align" and "text_wrap" arguments.

commit 84b247fab70e9b76539c2a0e24556e7c66126974 (tag: v9.0.0125)
Date:   Mon Aug 1 11:17:40 2022 +0100

    patch 9.0.0125: cursor positioned wrong with virtual text after the line
    
    Problem:    Cursor positioned wrong with virtual text after the line.
    Solution:   Clear cts_with_trailing.

commit 1f4ee19eefecd8f70b7cbe8ee9db8ace6352e23e (tag: v9.0.0130)
Date:   Mon Aug 1 15:52:55 2022 +0100

    patch 9.0.0130: cursor position wrong when inserting around virtual text
    
    Problem:    Cursor position wrong when inserting around virtual text.
    Solution:   Update the cursor position properly.

commit 783ef7214b6a33300bd83f616c1ead587370ce49 (tag: v9.0.0131)
Date:   Mon Aug 1 16:11:06 2022 +0100

    patch 9.0.0131: virtual text with Tab is not displayed correctly
    
    Problem:    Virtual text with Tab is not displayed correctly.
    Solution:   Change any Tab to a space.

commit 1f4ee19eefecd8f70b7cbe8ee9db8ace6352e23e (tag: v9.0.0130)
Date:   Mon Aug 1 15:52:55 2022 +0100

    patch 9.0.0130: cursor position wrong when inserting around virtual text
    
    Problem:    Cursor position wrong when inserting around virtual text.
    Solution:   Update the cursor position properly.
commit 84b247fab70e9b76539c2a0e24556e7c66126974 (tag: v9.0.0125)
Date:   Mon Aug 1 11:17:40 2022 +0100

    patch 9.0.0125: cursor positioned wrong with virtual text after the line
    
    Problem:    Cursor positioned wrong with virtual text after the line.
    Solution:   Clear cts_with_trailing.

commit 1f4ee19eefecd8f70b7cbe8ee9db8ace6352e23e (tag: v9.0.0130)
Date:   Mon Aug 1 15:52:55 2022 +0100

    patch 9.0.0130: cursor position wrong when inserting around virtual text
    
    Problem:    Cursor position wrong when inserting around virtual text.
    Solution:   Update the cursor position properly.

commit 783ef7214b6a33300bd83f616c1ead587370ce49 (tag: v9.0.0131)
Date:   Mon Aug 1 16:11:06 2022 +0100

    patch 9.0.0131: virtual text with Tab is not displayed correctly
    
    Problem:    Virtual text with Tab is not displayed correctly.
    Solution:   Change any Tab to a space.

commit 09ff4b54fb86a64390ba9c609853c6410ea6197c (tag: v9.0.0132)
Date:   Mon Aug 1 16:51:02 2022 +0100

    patch 9.0.0132: multi-byte characters in virtual text not handled correctly
    
    Problem:    Multi-byte characters in virtual text not handled correctly.
    Solution:   Count screen cells instead of bytes.

commit e175dc6911948bcd0c854876b534fee62fb95b9f (tag: v9.0.0133)
Date:   Mon Aug 1 22:18:50 2022 +0100

    patch 9.0.0133: virtual text after line moves to joined line
    
    Problem:    Virtual text after line moves to joined line. (Yegappan
                Lakshmanan)
    Solution:   When joining lines only keep virtual text after the last line.

commit 398649ee44edeb309c77361de697320378104b70 (tag: v9.0.0139)
Date:   Thu Aug 4 15:03:48 2022 +0100

    patch 9.0.0139: truncating virtual text after a line not implemented
    
    Problem:    Truncating virtual text after a line not implemented.
                Cursor positioning wrong with Newline in the text.
    Solution:   Implement truncating.  Disallow control characters in the text.
                (closes #10842)

commit 2f83cc4cfa56750c91eb6daa8fde319bca032d18 (tag: v9.0.0142)
Date:   Fri Aug 5 11:45:17 2022 +0100

    patch 9.0.0142: crash when adding and removing virtual text
    
    Problem:    Crash when adding and removing virtual text. (Ben Jackson)
    Solution:   Check that the text of the text property still exists.

commit afd2aa79eda3fe69f2e7c87d0b9b4bca874f386a (tag: v9.0.0143)
Date:   Fri Aug 5 13:07:23 2022 +0100

    patch 9.0.0143: cursor positioned after virtual text in empty line
    
    Problem:    Cursor positioned after virtual text in empty line.
    Solution:   Keep cursor in the first column. (closes #10786)

commit 50e75fe8d8c8ab262ab5b11d1498e5628044e07c (tag: v9.0.0147)
Date:   Fri Aug 5 20:25:50 2022 +0100

    patch 9.0.0147: cursor positioned wrong after two "below" text properties
    
    Problem:    Cursor positioned wrong after two text properties with virtual
                text and "below" alignment. (Tim Pope)
    Solution:   Do not stop after a text property using MAXCOL. (closes #10849)

ommit 3ec3b8e92da8299bcbfd851fa76fccf5403e4097 (tag: v9.0.0148)
Date:   Fri Aug 5 21:39:30 2022 +0100

    patch 9.0.0148: a "below" aligned text property gets 'showbreak' displayed
    
    Problem:    A "below" aligned text property gets 'showbreak' displayed.
    Solution:   Do not use 'showbreak' before or in virtual text. (issue #10851)

commit 4d91d347e65a5621621ea1e3c97dce2c677ed71d (tag: v9.0.0151)
Date:   Sat Aug 6 13:48:20 2022 +0100

    patch 9.0.0151: a "below" aligned text property does not work with 'nowrap'
    
    Problem:    A "below" aligned text property does not work with 'nowrap'.
    Solution:   Start a new screen line to display the virtual text.
                (closes #10851)


Introduces winlinevars_T, draw_screen_line

commit 28c9f895716cfa8f1220bc41b72a534c0e10cabe (tag: v9.0.0205)
Date:   Sun Aug 14 13:28:55 2022 +0100

    
    Problem:    Cursor in wrong position when inserting after virtual text. (Ben
                Jackson)
    Solution:   Put the cursor after the virtual text, where the text will be
                inserted. (closes #10914)


commit 9e7e28fc4c32337f2153b94fb08140f47e46e35d (tag: v9.0.0208)
Date:   Sun Aug 14 16:36:38 2022 +0100

    patch 9.0.0208: the override flag has no effect for virtual text
    
    Problem:    The override flag has no effect for virtual text. (Ben Jackson)
    Solution:   Make the override flag work. (closes #10915)

commit c3a483fc3c65f649f9985bb88792a465ea18b0a2 (tag: v9.0.0210)
Date:   Sun Aug 14 19:37:36 2022 +0100

    patch 9.0.0210: 'list' mode does not work properly with virtual text
    
    Problem:    'list' mode does not work properly with virtual text.
    Solution:   Show the "$" at the right position. (closes #10913)

commit d8d4cfcb393123fa19640be0806091d47935407f (tag: v9.0.0214)
Date:   Mon Aug 15 15:55:10 2022 +0100

    patch 9.0.0214: splitting a line may duplicate virtual text
    
    Problem:    Splitting a line may duplicate virtual text. (Ben Jackson)
    Solution:   Don't duplicate a text property with virtual text. Make
                auto-indenting work better. (closes #10919)


commit f396ce83eebf6c61596184231d39ce4d41eeac04 (tag: v9.0.0247)
Date:   Tue Aug 23 18:39:37 2022 +0100

    patch 9.0.0247: cannot add padding to virtual text without highlight
    
    Problem:    Cannot add padding to virtual text without highlight.
    Solution:   Add the "text_padding_left" argument. (issue #10906)

commit f5240b96f721b08d703340ff0b2e67b79fb8b821 (tag: v9.0.0252)
Date:   Wed Aug 24 12:24:37 2022 +0100

    patch 9.0.0252: cursor in wrong place after virtual text
    
    Problem:    Cursor in wrong place after virtual text.
    Solution:   Do not change the length of a virtual text property.
                (closes #10964)

