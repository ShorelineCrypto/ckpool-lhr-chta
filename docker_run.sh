docker run -d \
  --name ckpool-lhr-chta \
  --restart unless-stopped \
  -p 3433:3433 \
  -v $(pwd)/conf:/etc/ckpool \
  -v $(pwd)/logs:/var/log/ckpool \
  ckpool-lhr-chta:latest
