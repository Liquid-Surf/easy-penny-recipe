# Build stage
FROM node:18-alpine as build

#ENV NODE_VERSION 16.20.0

# Set current working directory
WORKDIR /community-server

# Copy the dockerfile's context's community server files
COPY . .

# Install and build the Solid community server (prepare script cannot run in wd)
RUN npm i --unsafe-perm 



# Runtime stage

FROM node:18-alpine

#ENV NODE_VERSION 16.20.0


# Add contact informations for questions about the container
LABEL maintainer="Solid Community Server Docker Image Maintainer <thomas.dupont@ugent.be>"

# Container config & data dir for volume sharing
# Defaults to filestorage with /data directory (passed through CMD below)
RUN mkdir -p /data

# Set current directory
WORKDIR /community-server

# Copy runtime files from build stage
COPY --from=build /community-server/package.json .
COPY --from=build /community-server/node_modules ./node_modules
COPY --from=build /community-server/config.json .
COPY ./templates ./templates
COPY ./styles ./styles


# Informs Docker that the container listens on the specified network port at runtime
EXPOSE 3056

# Set command run by the container
ENTRYPOINT ["npm", "run", "start:docker"]

# By default run in filemode (overriden if passing alternative arguments or env vars)
# ENV CSS_CONFIG=./config.json
# ENV CSS_ROOT_FILE_PATH=/data

