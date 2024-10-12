# bfxslt
A Brainf*ck interpreter written in XSLT.

## How to Run

### Using xsltproc

1. Install xsltproc:
   ```shell
   sudo apt install xsltproc
   ```
2. Run the program:
   ```shell
   xsltproc bf.xsl sample/hello.xml
   ```

#### Using Saxon-HE.jar

1. Install Java and Saxon-HE
   ```shell
   sudo apt install default-jre libsaxonhe-java
   ```
2. Run the program:
   ```shell
   java -jar /usr/share/java/Saxon-HE.jar -xsl:bf.xsl sample/toupper.xml 
   ```

### Running in the WebBrowser

1. Start a local web server using Docker:
   ```shell
   docker run --rm -d -p 8080:80 -v $(pwd):/usr/share/nginx/html nginx
   ```
   _Note: Ensure the correct path is specified in the -v option._
2. Access to the following URL:
   - [http://localhost:8080/sample/hello.xml](http://localhost:8080/sample/hello.xml)

Recent major browsers natively support XSLT 1.0.
Since the sample hello.xml already includes the XSLT stylesheet link,
you should be able to see the output by following the above steps.


## Brainf*ck in XML

In `bfxslt`, each bf command is represented by a corresponding XML tag:

| command   | XML tag                    |
|-----------|:---------------------------|
| `>`       | `<right/>`                 |
| `<`       | `<left/>`                  |
| `+`       | `<inc/>`                   |
| `-`       | `<dec/>`                   |
| `[ ... ]` | `<loop> ... <end/></loop>` |
| `,`       | `<read/>`                  |
| `.`       | `<print/>`                 |

### Example

Here’s a sample bf program that outputs the letter `A`:
```brainfuck
++++[->++++[->++++<]<]>>+.
```

This program is represented in XML as follows:
```xml
<?xml version="1.0" encoding="utf-8"?>
<bf>
  <code>
    <inc/><inc/><inc/><inc/>
    <loop>
      <dec/><right/><inc/><inc/><inc/><inc/>
      <loop>
        <dec/><right/><inc/><inc/><inc/><inc/><left/>
        <end/>
      </loop>
      <left/>
      <end/>
    </loop>
    <right/><right/><inc/><print/>
  </code>
</bf>
```
