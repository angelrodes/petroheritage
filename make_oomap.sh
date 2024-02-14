#!/bin/bash

# Input CSV file if provided
if [ $# -eq 0 ]; then
    input_file="database.csv"
    else
    input_file=$1
fi
echo "Input file: $input_file"

# Output HTML file
output_file="map.html"

# Pictures address
pics_address="https://raw.githubusercontent.com/angelrodes/petroheritage/main/pics/"
icons_address="https://raw.githubusercontent.com/angelrodes/petroheritage/main/icons/"

# Start HTML file
cat <<EOF > $output_file
<!DOCTYPE html>
<html>
<head>
    <title>Patrimonio petrológico</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=15">
    <link rel="stylesheet" href="https://unpkg.com/leaflet/dist/leaflet.css" />
    <script src="https://unpkg.com/leaflet/dist/leaflet.js"></script>
</head>
<body>
    <div id="map" style="height: 600px;"></div>

    <script>
        var map = L.map('map').setView([42.878753, -8.541904], 12); // Initial center and zoom level
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(map);
    // Include your custom icon images
    var iIcon = L.icon({
      iconUrl: 'https://raw.githubusercontent.com/angelrodes/petroheritage/main/icons/rock_r.png',
      iconSize: [32, 32], // size of the icon
      iconAnchor: [16, 32], // point of the icon which will correspond to marker's location
      popupAnchor: [0, -32] // point from which the popup should open relative to the iconAnchor
    });
    var mIcon = L.icon({
      iconUrl: 'https://raw.githubusercontent.com/angelrodes/petroheritage/main/icons/rock_b.png',
      iconSize: [32, 32], // size of the icon
      iconAnchor: [16, 32], // point of the icon which will correspond to marker's location
      popupAnchor: [0, -32] // point from which the popup should open relative to the iconAnchor
    });
    var sIcon = L.icon({
      iconUrl: 'https://raw.githubusercontent.com/angelrodes/petroheritage/main/icons/rock_g.png',
      iconSize: [32, 32], // size of the icon
      iconAnchor: [16, 32], // point of the icon which will correspond to marker's location
      popupAnchor: [0, -32] // point from which the popup should open relative to the iconAnchor
    });
    var defaultIcon = L.icon({
      iconUrl: 'https://raw.githubusercontent.com/angelrodes/petroheritage/main/icons/rock_w.png',
      iconSize: [32, 32], // size of the icon
      iconAnchor: [16, 32], // point of the icon which will correspond to marker's location
      popupAnchor: [0, -32] // point from which the popup should open relative to the iconAnchor
    });
EOF

# Read CSV file and add markers
name=0
tail -n +2 "$input_file" | while IFS=, read -r archivo latitud longitud  fecha_de_la_foto tipo_de_roca clasificacion formacion_litologica latitud_origen longitud_origen tipo_de_uso; do
    
    ((name++))
    picture_file=$(echo "pics/$archivo")
     description=$(echo "$tipo_de_uso: $tipo_de_roca ($clasificacion) - <a href=\"https://www.openstreetmap.org/?lat=$latitud_origen&lon=$longitud_origen&zoom=15&layers=M\">$formacion_litologica</a>")
     picture_address=$(echo "$pics_address$archivo")
     if [[ "${clasificacion:0:1}" == [Ii] ]]; then
         # Ignea
         icon_address=iIcon
    elif [[ "${clasificacion:0:1}" == [Ss] ]]; then
         # Sedimentaria
         icon_address=sIcon
     elif [[ "${clasificacion:0:1}" == [Mm] ]]; then
         # Metamorfica
         icon_address=mIcon
    else
         icon_address=defaultIcon
    fi

        echo "        L.marker([$latitud, $longitud], {icon: $icon_address}).addTo(map).bindPopup('<h3>$tipo_de_roca</h3><p>$description</p><img src=\"$picture_address\" alt=\"$name\" width=\"200\">');" >> $output_file
done >> $output_file

# End HTML file
cat <<EOF >> $output_file
    </script>
</body>
</html>
EOF

echo "HTML file generated: $output_file"

xdg-open $output_file
