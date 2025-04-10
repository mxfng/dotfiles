function brew_uninstall_all --description 'Safely uninstall all Homebrew packages'
    # List all installed packages
    set -l packages (brew list)

    if test -z "$packages"
        echo "No Homebrew packages installed."
        return 0
    end

    echo "The following packages will be uninstalled:"
    echo $packages
    echo ""
    echo "Are you sure you want to uninstall ALL Homebrew packages? (y/n)"
    read -l answer

    if test "$answer" = y
        echo "Uninstalling packages..."
        for package in $packages
            echo "Uninstalling $package..."
            brew uninstall --force $package
        end
        echo "All packages uninstalled."
    else
        echo "Operation cancelled."
    end
end
