# jwt.sh
Bash Script to create JWT tokens with HS256 and RS256

### Params:
```
 [jwt.sh]$ ./jwt.sh -h
./jwt.sh Params:
	-b | --b64url <value>		Convert <value> to base64Url and exit
	-a | --algorithm <value>	Set the algorithm to be used. Valid values are:
		* h | H | HMAC | HS256 -> for HMAC SHA256. This will require to set -S option
		* r | R | RSA | RS256  -> for RSA SHA256. This will require to set -P option
	-S | --secret <value>		Secret to be used with HS256
	-P | --pub-key | --pub <file>	Path to file with the Private RSA to sign the token
	-H | --header <value>		JSON value to set as header part of the JWT. If you don't specify this option, It will be generated automatically with -k | --kid value
	-p | --payload <value>		JSON value to set as payload part of the JWT
	-k | --kid <value>		Set the kid value to be used when autogenerating the header
```

### Usage:
- Getting Base64Url result for given text
```
 [jwt.sh]$ ./jwt.sh -b "hello world"
Base64Url:

aGVsbG8gd29ybGQ

 [jwt.sh]$
```

- Generating a HS256 JWT:
```
 [jwt.sh]$ ./jwt.sh -a HS256 -S my_secret -p '{"exp": "", "iat": "", "nbf": "", "sub": ""}'
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IiJ9.eyJleHAiOiIiLCJpYXQiOiIiLCJuYmYiOiIiLCJwb2wiOiIifQ.xJl5f5NuMTbITL9p3ahIiUtHCJPaAHw_NVyVPOfV4EM
 [jwt.sh]$ 
```

- Generating a RS256 JWT:
```
 [jwt.sh]$ ./jwt.sh -a RS256 -P private.pem -p '{"exp": "", "iat": "", "nbf": "", "sub": ""}'
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IiJ9.eyJleHAiOiIiLCJpYXQiOiIiLCJuYmYiOiIiLCJzdWIiOiIifQ.SSMbloBUqr_gdKAZQKW-egu9hFEvOfUEpmR2resJCED6U5mr3gQIbrhlKpNGB1m8b82wemMa2WAELhCxvNmyXJ3G437JW6e5SqPPZ1KDNSmpmUpEJH2-9TW11fHxeoVGZteeVBnb12P6OCt87MYmxLAJdqxR1qVLGmpn4RIAkU4HQWWnkLbe5AMlEk_MUzws4oSJvvbLIdhV-FO_vNm5dmYwDKlc9DrL-NKDm2aBrbElg_89iy9KnU4VNVj28VA40SZKKlpBcPvYCLh8DUXCpkA_jAH0VOQliONdqEBpe1YclAJJoqoeamEEOQVwV6mGQjl5qYDPWEZDfnFTHKFkiyF-RhXsXZAvVlSq_0OqkPf5zKt2iZb94yy5KVN7n99Ag5lvBnShR1AiC-Ve2todJ0SLdtNFEHb_6iIkERXZE_AZkmVFXB5kacpzD4_A3XIUSqVJsDdajkwYu_I9Jxd3-LwaTtU9JT1XiX-9qFZthKzwyjecHK-MSBW5laR7VhN4iMejbERvcJYQGrp_dULKYwjzNJvnKrewqZwfzpOuEcrIWbMiJayoSmB37Lx1lEUa_mPwpjxCKVEHcI849tFbetP9N7wlrZ_HDHSRkweTE6QgnVK1ojLQhn3BTW2ej32guPk5yQPuKDjA9HySMX5OxkSXmsw7ls_V-q3CmWNWDAQ
 [jwt.sh]$ 
```
