alias download_images="aws s3 sync s3://pdavidstestimages ~/pdavidstestimages"
alias add_extension="for img in *; do mv \"$img\" \"$img.jpg\"; done" # you really dont wanna run this one in the wrong directory
alias make_gif="convert -delay 42 -loop 0 *.jpg "

alias squish="osascript -e \"\$(curl https://gist.githubusercontent.com/MisterSquishy/165b47e89bd75e05ab5c5ecdde1ab2e9/raw)\""