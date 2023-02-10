
DEBUG=1

grep -r 'import ' $1 | while read -r line ; do
    python -c "$line" 2> /dev/null

    # If failed to import, try to install
    if [[ $? != 0 ]]; then
        # remove from, import, then everything that is after the '.'
        module=$line
        module=${module#from }
        module=${module#import }
        module=${module%%.*}
        if [[ $DEBUG != 0 ]]; then
            echo "Trying to install $module..."
        fi
        pip install $module &> /dev/null
        python -c "$line" 2> /dev/null
        if [[ $? != 0 ]]; then
            echo "Cannot install module with pip: $module"
        elif [[ $DEBUG == 0 ]]; then
            echo "Success"
        fi
    fi 
done
