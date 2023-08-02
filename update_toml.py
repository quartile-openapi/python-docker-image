import subprocess

import httpx
from tomlkit import dumps, parse

print("Updating pyproject.toml")
new_toml = httpx.get("https://raw.githubusercontent.com/quartile-openapi/python-docker-image/main/pyproject.toml").text
with open("pyproject.toml", "r") as f:
    old_toml = f.read()

new_toml = parse(new_toml)
old_toml = parse(old_toml)

print("Updating library version")
deps = new_toml["tool"]["poetry"]["group"]
# [tool.poetry.group.docker.dependencies]
old_toml["tool"]["poetry"]["group"]["docker"]["dependencies"] = deps["docker"]["dependencies"]
# [tool.poetry.group.dev.dependencies]
old_toml["tool"]["poetry"]["group"]["dev"]["dependencies"] = deps["dev"]["dependencies"]
# [tool.poetry.group.publish.dependencies]
old_toml["tool"]["poetry"]["group"]["publish"]["dependencies"] = deps["publish"]["dependencies"]
# [tool.poetry.group.others.dependencies]
old_toml["tool"]["poetry"]["group"]["others"]["dependencies"] = deps["others"]["dependencies"]

print("Changing the pyproject.toml file")
with open("pyproject.toml", "w") as f:
    f.write(dumps(old_toml))


# remove poetry lock
print("Removing poetry.lock")
subprocess.run(["rm", "-rf", "poetry.lock"], check=True)

# update poetry
print("Updating poetry")
subprocess.run(["poetry", "update"], check=True)


print("Done")
