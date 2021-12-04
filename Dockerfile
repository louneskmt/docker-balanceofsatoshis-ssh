FROM alexbosworth/balanceofsatoshis as bos-builder

FROM node:14-buster-slim as final

# Copy and install bos
COPY --from=bos-builder /app /app
RUN ln -s /app/bos /usr/local/bin

# Configure and start SSH 
RUN apt-get update \
 && apt-get install -y openssh-server

# Change node uid/gid
RUN groupmod -g 1001 node \
 && usermod -u 1001 -g 1001 node

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

CMD [ "/entrypoint.sh" ]