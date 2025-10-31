#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash -p xmlstarlet -p jq -p curl

file=$1

#TODO check arguments and display basic useage

function query(){
  xmlstarlet sel -t -m "${1}" -v "${2}" -n "${file}"
}

base_query='/cockatrice_deck/zone[@name="main"]/card'

function images_by_uuid(){
  query "${base_query}[@uuid]" "@uuid" | while read -r uuid
  do
    curl -s "https://api.scryfall.com/cards/${uuid}" 
  done
}

function images_by_name(){
  query "${base_query}[not(@uuid)]" "@name" | while read -r name
  do
    curl --get -s --data-urlencode "exact=${name}" "https://api.scryfall.com/cards/named"
  done
}

function extract_img_url() {
  jq -r '.image_uris.large'
}

function download_img() {
  while read -r url
  do
    wget -nv "$url" -O "./images/$(uuidgen).jpg"
  done
}


(images_by_name ; images_by_uuid) | extract_img_url | download_img
