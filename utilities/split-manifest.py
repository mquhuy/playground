import os
import sys

def split_yaml_file(filepath):
    absfilepath = os.path.abspath(filepath)
    filedir, filename = os.path.split(absfilepath)
    with open(filepath) as f:
        content = f.read()
    parts = content.split("---\n")
    parts.sort()
    new_content = "\n---\n".join(parts)
    with open(os.path.join(filedir, f"sorted_{filename}"), "w") as f:
        f.write(new_content)


if __name__ == "__main__":
    for arg in sys.argv[1:]:
        split_yaml_file(arg)
