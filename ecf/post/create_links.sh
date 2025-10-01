#!/bin/bash

target=jaigfs_post.ecf
for i in $(seq -w 0 6 384); do
  ln -s $target jaigfs_post_f${i}.ecf
done

