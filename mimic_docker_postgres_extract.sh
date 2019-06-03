wget --user YOURUSERNAME --ask-password -A csv.gz -m -p -E -k -K -np -nd https://physionet.org/works/MIMICIIIClinicalDatabase/files/

docker run --name mimic -p 5555:5432 -e BUILD_MIMIC=1 -e POSTGRES_PASSWORD=postgres -e MIMIC_PASSWORD=mimic -v “LOCALDAT:/mimic_data" -v “LOCALDB:/var/lib/postgresql/data" -d postgres/mimic


