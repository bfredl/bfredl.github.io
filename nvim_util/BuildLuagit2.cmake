include(CMakeParseArguments)

# BuildLuagit2(PATCH_COMMAND ... CONFIGURE_COMMAND ... BUILD_COMMAND ... INSTALL_COMMAND ...)
# Reusable function to build luagit2, wraps ExternalProject_Add.
# Failing to pass a command argument will result in no command being run
function(BuildLuagit2)
  cmake_parse_arguments(_luagit2
    ""
    ""
    "PATCH_COMMAND;CONFIGURE_COMMAND;BUILD_COMMAND;INSTALL_COMMAND"
    ${ARGN})

  if(NOT _luagit2_CONFIGURE_COMMAND AND NOT _luagit2_BUILD_COMMAND
       AND NOT _luagit2_INSTALL_COMMAND)
    message(FATAL_ERROR "Must pass at least one of CONFIGURE_COMMAND, BUILD_COMMAND, INSTALL_COMMAND")
  endif()

  ExternalProject_Add(luagit2-static
    PREFIX ${DEPS_BUILD_DIR}
    DEPENDS lua-compat-5.3
    URL ${LUV_URL}
    DOWNLOAD_DIR ${DEPS_DOWNLOAD_DIR}/luagit2
    DOWNLOAD_COMMAND ${CMAKE_COMMAND}
      -DPREFIX=${DEPS_BUILD_DIR}
      -DDOWNLOAD_DIR=${DEPS_DOWNLOAD_DIR}/luagit2
      -DURL=${LUV_URL}
      -DEXPECTED_SHA256=${LUV_SHA256}
      -DTARGET=luagit2-static
      # The source is shared with BuildLuarocks (with USE_BUNDLED_LUV).
      -DSRC_DIR=${DEPS_BUILD_DIR}/src/luagit2
      -DUSE_EXISTING_SRC_DIR=${USE_EXISTING_SRC_DIR}
      -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/DownloadAndExtractFile.cmake
    PATCH_COMMAND "${_luagit2_PATCH_COMMAND}"
    CONFIGURE_COMMAND "${_luagit2_CONFIGURE_COMMAND}"
    BUILD_COMMAND "${_luagit2_BUILD_COMMAND}"
    INSTALL_COMMAND "${_luagit2_INSTALL_COMMAND}")
