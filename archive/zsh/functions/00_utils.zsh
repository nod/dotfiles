# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*.z*; do
        source $config
      done
    fi

    for config in "$_dir"/*.z*; do
          source $config
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*.z*; do
        source $config
      done
    fi
  fi
}
