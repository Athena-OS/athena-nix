# Ranger plugin for storing metadata in extended file attributes
# Requires Python 3.3
# drop it in ~/.config/ranger/plugins

from ranger.ext.openstruct import DefaultOpenStruct as ostruct
import ranger.core.metadata
import os


def get_metadata(_, filename):
    attributes = os.listxattr(filename)
    metadata = {}
    for attribute in attributes:
        if attribute.startswith("user."):
            key = attribute[5:]
            value = os.getxattr(filename, attribute)
            metadata[key] = value.decode()
    return ostruct(metadata)


def set_metadata(_, filename, update_dict):
    for key in update_dict.keys():
        os.setxattr(filename, "user." + key, update_dict[key].encode())


ranger.core.metadata.MetadataManager.get_metadata = get_metadata
ranger.core.metadata.MetadataManager.set_metadata = set_metadata
