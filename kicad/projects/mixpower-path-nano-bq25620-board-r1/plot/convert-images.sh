#!/bin/sh

set -me

own_dir="$(dirname "$(realpath -s "$0")")"
max_jobs="4"
num_jobs="0"
dpi="400"
jpg_dpi="600"

# convert_file() (
#   local input_file="$1"
#   shift
#
#   local png_output_file="$(dirname "${input_file}")/$(basename "${input_file}" .svg).png"
#   local jpg_output_file="$(dirname "${input_file}")/$(basename "${input_file}" .svg).jpg"
#
#   printf '[[INFO]] CONVERTING: %s -> %s\n' "${png_output_file}" "${jpg_output_file}"
#   inkscape \
#     --export-dpi "${jpg_dpi}" \
#     --export-overwrite \
#     --export-type png \
#     --export-png-use-dithering false \
#     --export-png-color-mode RGBA_8 \
#     -o "${png_output_file}" \
#     "${input_file}"
#   magick \
#     -quality 75 \
#     "${png_output_file}" \
#     "${jpg_output_file}"
#
#   printf '[[INFO]] CONVERTING: %s -> %s\n' "${input_file}" "${png_output_file}"
#   inkscape \
#     --export-dpi "${dpi}" \
#     --export-overwrite \
#     --export-type png \
#     --export-png-use-dithering false \
#     --export-png-color-mode RGBA_8 \
#     -o "${png_output_file}" \
#     "${input_file}"
# )

printf '[[INFO]] Reading folder: %s\n' "${own_dir}"
find "${own_dir}" -name '*.svg' | while read input_file; do
  if [ "${num_jobs}" -ge "${max_jobs}" ]; then
    wait -n
  fi
  (
    png_output_file="$(dirname "${input_file}")/$(basename "${input_file}" .svg).png"
    jpg_output_file="$(dirname "${input_file}")/$(basename "${input_file}" .svg).jpg"

    printf '[[INFO]] CONVERTING: %s -> %s\n' "${png_output_file}" "${jpg_output_file}"
    inkscape \
      --export-dpi "${jpg_dpi}" \
      --export-overwrite \
      --export-type png \
      --export-png-use-dithering false \
      --export-png-color-mode RGBA_8 \
      -o "${png_output_file}" \
      "${input_file}"
    magick \
      -quality 75 \
      "${png_output_file}" \
      "${jpg_output_file}"

    printf '[[INFO]] CONVERTING: %s -> %s\n' "${input_file}" "${png_output_file}"
    inkscape \
      --export-dpi "${dpi}" \
      --export-overwrite \
      --export-type png \
      --export-png-use-dithering false \
      --export-png-color-mode RGBA_8 \
      -o "${png_output_file}" \
      "${input_file}"

    # wait
  ) &
  num_jobs=$((num_jobs+1))
  # Sleep here should NOT be needed.
  # See: https://gitlab.com/inkscape/inkscape/-/work_items/4716
  sleep 0.5
done

# Does not actually wait for all jobs to finish, because of... subshells? Multiple commands? Why doesn't it work?
wait
