docker run --workdir /build/hypnoscope -p 3838:3838 -it --rm -d --name hypno remnrem/luna
echo "\n"
echo "Launching Hypnoscope..."
echo "Use your browser to visit: http://127.0.0.1:3838/"
echo "\n"
docker exec hypno /usr/local/bin/Rscript -e 'library(shiny); runApp(port = 3838, host = "0.0.0.0", launch.browser = F)'
