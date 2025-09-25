# mlgfs
Machine Learning Global Forecast System

# Instructions for production use
Link `ecf/post/jaigfs\_post.ecf` to forecast hours


```bash
$ for fh in $( seq -f "%03g" 0 384 ); do \
   ln -sf jaigfs_post.ecf jaigfs_post_f${fh}.ecf; \
   done
```
