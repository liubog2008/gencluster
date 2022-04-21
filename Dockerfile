FROM python:3.7-slim AS dep

# Install tools required to build the project
# We need to run `docker build --no-cache .` to update those dependencies

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pipenv

# These layers are only re-built when pip files are updated
COPY Pipfile.lock Pipfile /app/
WORKDIR /app/
# Install library dependencies
RUN PIPENV_VENV_IN_PROJECT=true pipenv install --pypi-mirror https://pypi.tuna.tsinghua.edu.cn/simple

# This results in a single layer image
FROM python:3.7-slim

COPY --from=dep /app /app
COPY . /app

RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pipenv

RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && apt-get update && apt-get install openssh-client sshpass iputils-ping vim -y

WORKDIR /app/

CMD ["pipenv", "shell"]

