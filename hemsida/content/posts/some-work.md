+++
title = "The screen grid representation in nvim"
date = "2022-11-16T10:16:15+01:00"
author = "bfredl"
authorTwitter = "bfredlbfredl" #do not include @
cover = ""
keywords = ["", ""]
description = "More description"
showFullContent = false
draft = true
+++

This blogpost will describe both some historical work to refactor
the internal representation of the Screen Grid in nvim.

Multi-byte text representation
=====

- 2016: `encoding=utf-8` only
- 2018: UTF-8 strings
- 2023: interned strings

Right-left rendering
============
Mirrors are more fun than television.

More internal refactors
=====
The "two paths" refactor, message.c stuff. link to the comment message essays.

Screen Tests
============

One important aspect in this work has been the growth of a large suite of tests
This was introduced [very early as part the external UI protocol](https://github.com/neovim/neovim/pull/1605)

This allows you to write tests like

   ...

then `screen:snapshot_util()` will expand to the code needed to expect the exact screen state

   ...

Over time, this has grown to over 4000 individual calls to expect testing the entire or some part of the screen,
both for pre-existing vim features and newly implemented features.

This has allowed us to do larger and deeper refactors with confidence which wouldn't be possible otherwise.

