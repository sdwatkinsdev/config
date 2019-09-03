# Defined in /var/folders/13/v848c16152db81ggkbd863m40000gp/T//fish.CTcHgL/gc.fish @ line 2
function gc
	set msg (echo $argv)
    git commit -m "$msg"
end
