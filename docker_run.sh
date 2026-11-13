docker run -d \
  --name ckpool-lhr-chta \
  --restart unless-stopped \
  -p 3333:3333 \
  -v $(pwd)/conf:/etc/ckpool \
  -v $(pwd)/logs:/var/log/ckpool \
  ckpool-lhr-chta:latest
