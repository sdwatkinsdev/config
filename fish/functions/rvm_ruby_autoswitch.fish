function rvm_ruby_autoswitch --on-variable PWD
  # Source a .rvmrc file in a directory after changing to it, if it exists.
  # To disable this feature, set rvm_project_rvmrc=0 in $HOME/.rvmrc
  if test "$rvm_project_rvmrc" != 0
    set -l cwd $PWD
    while true
      if contains $cwd "" $HOME "/"
        if test "$rvm_project_rvmrc_default" = 1
          rvm default 1>/dev/null 2>&1
        end
        break
      else
        if test -e .rvmrc -o -e .ruby-version -o -e .ruby-gemset
          eval "rvm reload" > /dev/null
          eval "rvm rvmrc load" >/dev/null
          break
        else
          set cwd (dirname "$cwd")
        end
      end
    end

    set -e cwd
  end
end
