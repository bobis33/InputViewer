find_package(Doxygen)

if (DOXYGEN_FOUND)
    set(DOXYGEN_DIR ${CMAKE_SOURCE_DIR}/.doxygen)
    set(DOXYFILE_IN ${DOXYGEN_DIR}/Doxyfile)
    set(DOXYFILE_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)

    configure_file(${DOXYFILE_IN} ${DOXYFILE_OUT} @ONLY)

    doxygen_add_docs(doxygen
            ${CMAKE_SOURCE_DIR}/include
            ${CMAKE_SOURCE_DIR}/src
            ${CMAKE_SOURCE_DIR}/lib/local/static/myLib/include
            ${CMAKE_SOURCE_DIR}/lib/local/static/myLib/src
            COMMENT "Generate API documentation for InputViewer"
    )

    add_custom_command(TARGET doxygen POST_BUILD
            WORKING_DIRECTORY ${DOXYGEN_DIR}
            COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYFILE_OUT}
            VERBATIM
    )

    add_custom_command(TARGET doxygen POST_BUILD
            WORKING_DIRECTORY ${DOXYGEN_DIR}/latex
            COMMAND ${CMAKE_MAKE_PROGRAM} > /dev/null && ${CMAKE_COMMAND} -E copy refman.pdf ${CMAKE_SOURCE_DIR}/InputViewer.pdf
            BYPRODUCTS ${CMAKE_SOURCE_DIR}/InputViewer.pdf
            VERBATIM
    )

else ()
    message(WARNING "Doxygen not found")
endif ()
