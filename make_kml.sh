#!/bin/bash

# Input CSV file if provided
if [ $# -eq 0 ]; then
    input_file="database.csv"
    else
    input_file=$1
fi
echo "Input file: $input_file"

# Pictures address
pics_address="https://raw.githubusercontent.com/angelrodes/petroheritage/main/pics/"
icons_address="https://raw.githubusercontent.com/angelrodes/petroheritage/main/icons/"

# Output KML file
output_file="sites.kml"

# Start KML file
cat <<EOF > $output_file
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
EOF

# Read CSV file
name=0
tail -n +2 "$input_file" | while IFS=, read -r archivo latitud longitud  fecha_de_la_foto tipo_de_roca clasificacion formacion_litologica latitud_origen longitud_origen tipo_de_uso; do
    
    ((name++))
    picture_file=$(echo "pics/$archivo")
     description=$(echo "$tipo_de_uso: $tipo_de_roca ($clasificacion) - <a href=\"https://www.google.com/maps?q=$latitud_origen,$longitud_origen\">$formacion_litologica</a>")
     picture_address=$(echo "$pics_address$archivo")
     if [[ "${clasificacion:0:1}" == [Ii] ]]; then
         # Ignea
         icon_address=$(echo "${icons_address}rock_r.png")
    elif [[ "${clasificacion:0:1}" == [Ss] ]]; then
         # Sedimentaria
         icon_address=$(echo "${icons_address}rock_g.png")
     elif [[ "${clasificacion:0:1}" == [Mm] ]]; then
         # Metamorfica
         icon_address=$(echo "${icons_address}rock_b.png")
    else
         icon_address=$(echo "${icons_address}rock_w.png")
    fi

    # Create KML placemark 
    cat <<EOF >> $output_file
    <Placemark>
        <name>$name</name>
        <description>
        <![CDATA[
        <img src="$picture_address" alt="$tipo_de_roca" width="300">
        <p>$description</p>
        ]]>
        </description>
        
        <Point>
            <coordinates>$longitud,$latitud</coordinates>
        </Point>
        <Style>
            <IconStyle>
                <Icon>
                    <href>$icon_address</href>
                </Icon>
            </IconStyle>
        </Style>
    </Placemark>
EOF
done

# End KML file
cat <<EOF >> $output_file
</Document>
</kml>
EOF

echo "KML file generated: $output_file"
