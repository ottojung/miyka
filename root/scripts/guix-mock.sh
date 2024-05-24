#! /bin/sh

case "$1" in
    "describe")
        echo "(some channels info)"
        exit 0
        ;;

    "shell")

        while true
        do
            if test $# = 0
            then exit 1
            fi

            case "$1" in
                "--")
                    shift
                    break
                    ;;
                *)
                    shift
                    ;;
            esac
        done

        exec "$@"

        ;;
esac
