#!/bin/bash
proj="dppl"

function bootstrap {
    local py=`which python`

    echo "---"
    echo "Installing Packages"
    echo "---"
    pip install -r "requirements.pip";
    echo ""

    echo "---"
    echo "Updating local_settings.py"
    echo "---"
    cp "source/local_settings.py.example" "source/local_settings.py";
    read -p "What is your mysql username? " username
    read -s -p "What is your mysql password? " password
    sed -i "s/'PASSWORD': \"root\"/'PASSWORD': \"${password}\"/g" "source/local_settings.py"
    echo ""
    echo ""

    echo "---"
    echo "Creating Database"
    echo "---"
    mysql -u $username -p$password -e "CREATE DATABASE ${proj};"
    $py "source/manage.py" syncdb --settings=source.settings
    echo ""

    echo ""
    echo "Finished."
    echo ""
}

function myhelp {
    echo ""
    echo "To install virtualenv, check this out: http://www.doughellmann.com/docs/virtualenvwrapper/"
    echo ""
    echo "After installing, run:"
    echo "    mkvirtualenv ${proj} --no-site-packages && workon ${proj}"
    echo ""
    echo "Then run this script again."
    echo ""
}

echo "Are you currently using your virtualenv? "
select yn in "Yes" "No"; do
    case $yn in
        Yes ) bootstrap; break;;
        No ) myhelp; exit;;
    esac
done