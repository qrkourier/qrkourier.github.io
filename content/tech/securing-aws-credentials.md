Title: Securing AWS Credentials
Tags: aws, sysadmin, Linux, MacOS, identity, encryption
Icon: fab fa-aws

A single [rogue npm module](https://github.com/joho/aws-pony), Ruby gem, PyPi module, or ill-fated cURL command could expose you (and your employer) to extreme risk.

[TOC]

## Is this you?

```ini
# ~/.aws/credentials
[default]
aws_access_key_id=AKIAIH7UMBRMK5L7GT2Q
aws_secret_access_key=kyLQmrtPwdXrXdxiAOjS1v0zrR06CiEzKKWXIRum
```

</br>

If you have this file it is probably so that you can use the credentials with awscli or another command-line utility, or so that you can test a native build of your application that calls AWS in an IDE or when invoked by a build tool such as Maven. We'll explore a specific case as representative of a broad class of vulnerabilities, specifically how a sensitive file could be stolen and how you can make that prohibitively difficult.

### The Problem

You are vulnerable to the theft and misuse of your AWS identity if:

  1. you lose your non-encrypted computer disk where the file is stored, or
  2. a malicious process designed to steal this credential runs on your computer.

This attack is not unique to AWS, of course. Many development and systems administration tools follow the same pattern of issuing an API token as a primary trust factor. Proper handling of these token is too often an afterthought, and we can only surmise that the implications of that carelessness are truly not appreciated by a significant number of software developers. [The discovery that hundreds of mobile apps had hard-coded API keys for the Twilio platform](https://www.cyberscoop.com/twilio-api-eavesdropper-vulnerability/) is evidence of the same.

Suppose your employer requires full-disk encryption for all company-provided equipment. In that case a loss of custody of your portable development machine; while inconvenient and frustrating and definitely a security incident; is not a situation worsened by the further implications of a data leak or identity theft. Even with that considerable degree of protection in place, there is another constellation of attack vectors not at all mitigated by full-disk encryption. How many times have your downloaded a utility or app directly from the author or vendor by pasting a `curl` or `wget` command into your terminal or downloaded an executable or package file? In every case this action implies the delegation of your own privileges on that computer to whomever authored the code that you just executed.

Your computer doesn't know the difference between you and your logged-in user, and it's that user that owns all of your files and runs all of your processes. That user mostly runs programs written by people other than you. Those programs, running as your user, could read and upload your AWS credentials or any other file for that matter if the source code were maliciously modified to do so. There would be no barrier to that malicious code reading the file, initiating the egressing network connection, nor any tell.

Importantly, it is possible to dramatically reduce the scope of code that you actually trust in order to operate normally.

### A Solution

You can store secrets safely on disk with encryption, decrypt just-in-time to use them normally, and destroy the plaintext.

Here's a way to do this with PGP that doesn't require you to type a passphrase every time you wish to read the plaintext. With this approach access to the plaintext is controlled by the GnuPG agent and OS login keyring.

_This applies to Bourne-compat shells on file-based OSs e.g. BASH and ZSH on MacOS or Linux_

```shell
❯ source <(gpg -qd ~/.aws/credentials.gpg)
```
</br>

The plaintext of this file is shellcode like...
```shell
export AWS_ACCESS_KEY_ID=AKIAJS7UXB9INMRXLOEA
export AWS_SECRET_ACCESS_KEY=vXHZEOVxrBtqMkmadkJv0mCeEglrlFA5oBEywSFw
```
</br>
...which makes these values available in the current process environment as well as any child processes' environments. This reduces the surface area for attack by eliminating attack vectors based on filesystem semantics. It is still possible on some operating systems for any process running as *you* to read the environment variable with which future child processes are invoked, but those processes are likely to be short-lived and will have unpredictable process IDs which are needed to address the process environment directly. Basically, this makes lifting the credential from your computer difficult.

### Do it Yourself

Composing your own encrypted credentials file requires only free, open-source utilities that run on file-based OSs like Linux, MacOS. I'll assume you are using a Bourne-compat shell e.g. BASH, ZSH. You're on your own for API-based OSs like Windows, but I believe this same approach could work there as well. If you get it working and send me the recipe I'll post it here.

These steps will allow you to continue using the Default Credential Provider chain in AWS SDKs, boto3/awscli, etc...

  * Install and configure GnuPG command-line interface (CLI) for your OS. I'll assume this will also provide the GnuPG agent which is typically included with modern, trusted GPG packages. [This blog post](http://blog.ghostinthemachines.com/2015/03/01/how-to-use-gpg-command-line/) looks like a good place to start.

    _You will need the user ID (UID) e.g. alice@example.com that you choose in this step in a later step._

  * Use GnuPG CLI `gpg` to create an identity aka PGP private key. Github has [a helpful post](https://help.github.com/articles/generating-a-new-gpg-key/) about this.

  * Install the AWS CLI which we'll use to verify these steps work. Amazon covers this [on their web site](https://aws.amazon.com/cli/).

  * If you have more than one credential in *~/.aws/credentials* then copy each to a separate file with a meaningful name e.g. *~/.aws/credentials-example.com* and perform the next step for each file.

  * Edit the plaintext file *~/.aws/credentials* so that it resembles the example above. You can manually insert the `export` command at the beginning of the two lines and convert the variables names to uppercase or you can run this command which does precisely that in the terminal to prepare the file for encryption.

```shell
❯ sed -E -e '/^\[.*\]$/d' \
         -e 's/^(\s+)?(aws_(secret_)?access_key(_id)?)(\s+)?=(\s+)?/export \U\2=\E/g' \
         -i ~/.aws/credentials
```

</br>

  * Encrypt the credentials file for your user ID (typically the email address you entered when the PGP identity was generated).
```shell
# this command creates a new file with the same filename as the plaintext + suffix ".gpg"
❯ gpg -e -{u,r}alice@example.com ~/.aws/credentials
```
</br>

* Prove you can decrypt.
```shell
❯ gpg -qd < ~/.aws/credentials.gpg
```
</br>
If this is the first time you have used your PGP identity you may see a GUI popup in your OS prompting for your passphrase. If your OS+GnuPG agent integration allows you may at this time also save the passphrase in your OS keyring. This probably means that your passphrase is chained to your OS login password, and so you should protect that login password with the same measures that are appropriate for your AWS credential.

* Source the plaintext into your shell environment and use the credential to authenticate.
```shell
❯ source $(gpg -qd < ~/.aws/credentials.gpg)

❯ aws iam get-user
```
</br>

* If you will be switching between multiple credentials with this method then simply source the plaintext from separate files.
```shell
❯ source $(gpg -qd < ~/.aws/credentials-example.com.gpg)
❯ source $(gpg -qd < ~/.aws/credentials-example.org.gpg)
```
</br>

* Now you can delete the plaintext file. If you are feeling less than confident about your future ability to decrypt with your PGP identity then, as a fallback option, consider changing the filemode on the plaintext credentials file so that elevated privileges are required to read it.
```shell
❯ rm ~/.aws/credentials
# alternatively, make the file unreadable by unprivileged processes
❯ sudo chown root ~/.aws/credentials
❯ sudo chmod 0600 ~/.aws/credentials
```
</br>

## Shortcuts

### Enable Privileges

There's no need to memorize the terminal commands. You can save a shellcode "alias" or create a shellcode function to assume any AWS identity for which you have encrypted credentials.

First, lets look at the most simple case where you have exactly one AWS credential encrypted with the above procedure in *~/.aws/credentials.gpg*.

```shell
# save the following alias in your aliases dotfile or shell runcom file e.g. ~/.bashrc
alias onaws="source <(gpg -qd ~/.aws/credentials.gpg)"
```
</br>

```shell
# alternatively, you could make this default AWS credential available in every new shell
# environment by including the source command in the shell rc file
source <(gpg -qd ~/.aws/credentials.gpg)
```
</br>

```shell
# source the shell rc file (this happens automatically for your next terminal session)
❯ source ~/.bashrc

# then exec the alias to assume the AWS identity
❯ onaws
```
</br>

If instead you have multiple AWS identities you could use a shellcode function and a file naming convention to quickly assume any one identity.
```shell
# save the following function in your aliases dotfile or shell runcom file e.g. ~/.bashrc
onaws(){
  local CREDFILE=~/.aws/credentials
  [[ $# -eq 1 ]] && {
    CREDFILE=${CREDFILE}-${1}.gpg
  } || {
    CREDFILE=${CREDFILE}.gpg
  }
  [[ -r $CREDFILE && -s $CREDFILE ]] && {
    source <(gpg -qd $CREDFILE)
  } || {
    echo "ERROR: $CREDFILE is not readable, or is nonexistent or empty; bye."
    return 1
  }
}
```
</br>

```shell
# source the shell rc file (this happens automatically for your next terminal session)
❯ source ~/.bashrc

# then exec the function with a positional parameter matching the filename to assume a particular
# AWS identity e.g. stored in ~/.aws/credentials-example.com.gpg
❯ onaws example.com
```
</br>

### Disable Privileges

You may wish to immediately nullify any credentials and session tokens in memory. You're relatively safe if you end the process where the credentials were sourced, but if for some reason it is preferable for that process to continue running you can explicitly unset the variables with a command.
```shell
# save the following alias in your aliases dotfile or shell runcom file e.g. ~/.bashrc
alias noaws="unset AWS_ACCESS_KEY \
                   AWS_ACCESS_KEY_ID \
                   AWS_SECRET_ACCESS_KEY \
                   AWS_SECURITY_TOKEN \
                   AWS_SESSION_TOKEN"
```
</br>

```shell
# source the shell rc file (this happens automatically for your next terminal session)
❯ source ~/.bashrc

# then exec the alias to drop privileges for which ever identity is currently active as well as any
# Simple Token Service sessions you might have obtained via `assume-role`
❯ noaws
```
</br>

### Assume Role

This describes another approach to gaining privileges in AWS and requires that an AWS IAM "role" has already been defined to control access to your resources. This is a global entity in your account that couples an IAM policy to any number of IAM users thereby allowing some action on some resource.

This is similar but different from using IAM groups to assign the same privileges to multiple users in that it enables granting privileges that span AWS accounts and provides only time-limited, non-interactive session tokens. This is also contrasting to the cumbersome practice of having many IAM user credentials for many AWS accounts because.

It is ideal to grant minimum privileges to a particular role in your own AWS account, and then grant to humans and robots the ability to assume that role with their own IAM user identity. That way they need only one identity regardless of to which AWS account their IAM user belongs, and you can modify the grants for the role in your own AWS account at any time. This also means you never need to know another user's secret access key, and you can still enforce criteria such as multi-factor authentication.

I've cobbled together [some additional shellcode functions](https://github.com/qrkourier/ansible-credstash/blob/master/aws-assume-role.sh) (originally to allow Ansible playbooks to assume an IAM role) that implement the following workflow:

  1. source an IAM user identity from an encrypted credentials file
  2. assume a particular IAM role for the maximum allowed session time (one hour)
    a. skip assuming role if a session token is already available in a temporary file, and
    b. prompt for second trust factor (MFA OTP)
    c. warn if the session token expiry is imminent
  3. drop privileges

## Related

There are ready-made utilities that also help with properly handling AWS credentials, but that obfuscate the handling of secrets, may place limitations on the way those secrets are used, and are not portable between ubiquitous shell environments. The above is a DiY solution that minimizes the needful trust of yet another piece of software and introduces no limitations to the `aws` CLI or the default AWS credential discovery chain employed by most other tools. If you're just looking for a convenient remediation for MacOS, then these may be best for you.

  * 99Designs has [a utility called aws-vault](https://99designs.com/tech-blog/blog/2015/10/26/aws-vault/) for MacOS

  * [aws-keychain](https://github.com/pda/aws-keychain) for MacOS

AWS publishes [best practices for identity access management](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html).

---

##Comments
<blockquote class="reddit-card" data-card-created="1526756360"><a href="https://www.reddit.com/user/bingnet/comments/8knauq/securing_aws_credentials/">Securing AWS Credentials</a> from <a href="http://www.reddit.com/u/bingnet">u/bingnet</a></blockquote>
<script async src="//embed.redditmedia.com/widgets/platform.js" charset="UTF-8"></script>
