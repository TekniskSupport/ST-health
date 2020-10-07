# -*- coding: utf-8 -*-
import sys, json
import slugify as unicode_slug

d = sys.argv[1]
matchingDevices = []

def slugify(text: str, *, separator: str = "_") -> str:
    """Slugify a given text."""
    return unicode_slug.slugify(text, separator=separator)  # type: ignore

def main():
    with open('hassDevices.json') as json_file:
        data = json.load(json_file)
        for device in data:
            if device["entity_id"].split(".")[1].rsplit("_", 1)[0] == slugify(d.lower()):
                matchingDevices.append(device["entity_id"])
            if device["entity_id"].split(".")[1] == slugify(d.lower()):
                matchingDevices.append(device["entity_id"])
            if "friendly_name" in device["attributes"]:
                if device["attributes"]["friendly_name"] == d:
                    matchingDevices.append(device["entity_id"])
    for device in list(set(matchingDevices)):
        print(device)

if __name__ == "__main__":
    main()
