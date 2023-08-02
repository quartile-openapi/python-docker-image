# Quartile Docker Image

This project builds a Python docker image as a base for Quartile projects.


## Development

### Requirements

* Python 3.10
* Poetry


### Update your project

The `update_toml.py` script will update the `pyproject.toml` file with the latest.
This guarantees that the docker image will be built with the latest version of the Quartile library.

#### Run the script in your project

```bash
python3 update_toml.py
```
