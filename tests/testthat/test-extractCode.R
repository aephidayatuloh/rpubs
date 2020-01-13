test_that("Length of vector result", {
  expect_equal(length(extractCode(url = "http://rpubs.com/aephidayatuloh/sendgmail")), 1)
})
