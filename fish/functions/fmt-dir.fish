# Defined in /var/folders/13/v848c16152db81ggkbd863m40000gp/T//fish.Kegm33/fmt-dir.fish @ line 1
function fmt-dir --argument folder
	set -q folder[1]
  or set folder "."
  find $folder[1] -name "*.xml" -type f -exec xmllint --output '{}' --format '{}' \;
end
