import Config

config :cloudfront_signer, CloudfrontSignerTest,
  domain: "https://somewhere.cloudfront.com",
  key_pair_id: "a_key_pair",
  private_key:
    System.get_env("TESTING_PRIVATE_KEY") ||
      raise("""
      environment variable TESTING_PRIVATE_KEY is missing.
      You can generate one by calling: openssl genpkey -algorithm RSA
      """)
