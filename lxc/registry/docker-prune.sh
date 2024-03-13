#!/usr/bin/env sh

# app cfg
userpass="REGISTRY_USR:REGISTRY_PWD"
registry="localhost:5000"
registry_url=http://$registry/v2
max_age=72

# init
headers="Accept: application/vnd.docker.distribution.manifest.v2+json, application/vnd.oci.image.manifest.v1+json, application/vnd.oci.image.index.v1+json"
ts_current_date=$(date +%s)

# list repos
repos=$(curl -sS -u "$userpass" "$registry_url/_catalog?n=250" | jq -r '.repositories[]')

for repo in $repos; do
  echo "- repo : $repo"
  json_tags=$(curl -sS -H "$headers" -u "$userpass" "$registry_url/$repo/tags/list")
  echo $json_tags | grep -q '"tags":null'
  if [ $? == 0 ]; then
    echo "  > no tags"
    continue;
  fi
  tags=$(echo $json_tags | jq -r '.tags[]')
  nb_tags=$(( $(echo $tags | tr -cd ' \t' | wc -c)+1 ))
  to_delete=""
  nb_delete=0
  for tag in $tags; do
    #content_digest=$(curl -sS -H "$headers" -u "$userpass" "$registry_url/$repo/manifests/$tag" | jq -r '.manifests | .[0].digest')
    #echo "  > tag $tag : $content_digest"
    #cfg_digest=$(curl -sS -H "$headers" -u "$userpass" "$registry_url/$repo/manifests/$content_digest" | jq -r '.config.digest')
    cfg_digest=$(curl -sS -H "$headers" -u "$userpass" "$registry_url/$repo/manifests/$tag" | jq -r '.config.digest')
    echo "  > tag $tag : $cfg_digest"
    date_created=$(curl -sS -H "$headers" -u "$userpass" "$registry_url/$repo/blobs/$cfg_digest" | jq -r '.created' | sed -e 's/T/ /g' -e 's/\.*\(.[0-9]\+\)Z//g')
    ts_date_created=$(date -d "$date_created" +%s)
    aged_hours=$(( (ts_current_date - ts_date_created) / 3600 ))
    echo "    $aged_hours hours ago"
    if [ $aged_hours -gt $max_age ]; then
      sha256=$(curl -s -I -H "$headers" -u "$userpass" "$registry_url/$repo/manifests/$tag" | grep -i 'docker-content-digest' | sed -e 's/\r$//' -e 's/\(.*\) \(sha256:\)\([a-f0-9]\+\)/\2\3/g')
      to_delete="$to_delete $sha256"
      nb_delete=$(( nb_delete+1 ))
      #echo "    > deleting $sha256"
      #curl -H "$headers" -X DELETE -u "$userpass" "$registry_url/$repo/manifests/$sha256"
    fi
  done
  if [ ! -z "$to_delete" ]; then
    if [ $nb_delete -lt $nb_tags ]; then
      echo "  o $nb_delete/$nb_tags tags should be deleted"
      for sha256 in $to_delete; do
        echo "    > deleting $sha256"
        curl -H "$headers" -X DELETE -u "$userpass" "$registry_url/$repo/manifests/$sha256"
      done
    else
      echo "  !! all tags are too old, but i am not removing them"
    fi
  fi
done
