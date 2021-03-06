## Watermark removal with ImageMagick

```bash
convert "$1" "$NON_TRANSPARENT_WATERMARKS" -compose DivideSrc -composite -quality 100 "${2%.*}.jpg"
#convert "$1" "$NON_TRANSPARENT_WATERMARKS" +level 0,66% ..."
# Usage
find -maxdepth 1 -type f | parallel dewatermark.sh {} out/{}
find ./out/ -maxdepth 1 -type f | parallel jpeg-recompress {} optimized/{/}
```

## BGP image format

- http://xooyoozoo.github.io/yolo-octo-bugfixes/#camel&bpg=s&jpg=s
- https://github.com/mirrorer/libbpg/tree/master/html

## JPEG manipulations

### Lossy minification

- https://github.com/danielgtaylor/jpeg-archive (mozjpeg) [online mozjpeg](https://imageoptim.com/mozjpeg)
- https://github.com/rflynn/imgmin

### Lossless compression

- See: image/jpegrescan
- [packJPG](http://packjpg.encode.ru/?page_id=17) (already in pcompress)

### JPEG artifacts removal

- http://www.vicman.net/jpegenhancer/ http://mirror.szepe.net/software/jpeginst.exe
- http://enhance.pho.to/
- http://www.topazlabs.com/dejpeg
- Photoshop / Ps Elements: Filter > Noise > Reduce Noise  [x] Remove JPEG Artifacts

### Enlarging

- http://www.alienskin.com/blowup/
- http://vectormagic.com/online/how_it_works
- [Inkscape Trace bitmap](https://inkscape.org/doc/tracing/tutorial-tracing.html)

### Scaling

- [GIMP Liquid rescale](http://liquidrescale.wikidot.com/)
- [Photoshop Content-Aware Scale](https://helpx.adobe.com/photoshop/using/content-aware-scaling.html)

### Super-Resolution demo

[Super-Resolution From a Single Image](http://www.wisdom.weizmann.ac.il/~vision/SingleImageSR.html)

Imitation with ImageMagick:
```
convert                       \
   small.png                  \
  -colorspace RGB             \
  +sigmoidal-contrast 11.6933 \
  -define filter:filter=Sinc  \
  -define filter:window=Jinc  \
  -define filter:lobes=3      \
  -resize 400%                \
  -sigmoidal-contrast 11.6933 \
  -colorspace sRGB            \
   better-quality-enlargement.png
```

### Online editors

- [Face retouch](http://makeup.pho.to/)
- [Editor.Pho.to](http://editor.pho.to/edit/)
- [Pixlr Editor](https://apps.pixlr.com/editor/)


### Invalidate objects on Amazon CloudFront

```bash
alias encodeURIComponent='perl -pe '\''s/([^a-zA-Z0-9_.!~*()'\''\'\'''\''-])/sprintf("%%%02X",ord($1))/ge'\'
cat $URL_LIST|while read URL;do echo -n "$URL"|encodeURIComponent;echo;done|sed 's/%2F/\//g'
```
