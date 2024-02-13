#!/bin/bash

# Input CSV file if provided
if [ $# -eq 0 ]; then
    input_file="database.csv"
    else
    input_file=$1
fi

# Pictures address
pics_address="https://raw.githubusercontent.com/angelrodes/petroheritage/91c43a09db7d667f02a9936cb505986ed9b114da/pics/"

# Output KML file
output_file="sites.kml"

# Start KML file
cat <<EOF > $output_file
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
<Document>
EOF

# Read CSV file
tail -n +2 "$input_file" | while IFS=, read -r name latitude longitude description picture_file; do
    # Check if picture file exists
    if [ ! -f "$picture_file" ]; then
        echo "Picture file '$picture_file' not found for site '$name'. Skipping."
        continue
    fi

    # Create KML placemark with picture
    cat <<EOF >> $output_file
    <Placemark>
        <name>$name</name>
        <description>$description</description>
        <Point>
            <coordinates>$longitude,$latitude</coordinates>
        </Point>
        <Style>
            <IconStyle>
                <Icon>
                    <href>$picture_file</href>
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
