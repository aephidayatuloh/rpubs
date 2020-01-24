# rpubs : Extract code from RPubs article

[RPubs.com](https://rpubs.com) is a web publishing service for R articles created from R Markdown. When you find some interesting article, may be you want to copy the script to try reproduce on your local machine. The \code{rpubs} package can help you to automatically copy and paste the script (or with the output) without you have to do it manually.

## Install

```
# install.packages("devtools")
devtools::install_github("aephidayatuloh/rpubs")
```

## Usage

```
library(rpubs)
article <- "https://rpubs.com/aephidayatuloh/sendgmail"
rpubs_code(url = article, path = "myfolder/sendgmail.R", output = FALSE)
```

If you run the code above, after the process finished you will have the script file named "sendgmail.R" in "myfolder"" folder. But, if the script in the article in a output-block part (this usually in a box with white background, different writing style from writer) then use \code{output = TRUE} to make the output-block part of script output file.

