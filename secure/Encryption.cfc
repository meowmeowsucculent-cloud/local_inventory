component displayname="Encryption" {

    public string function encryptForStorage(required string plaintext, required string key) {
        return encrypt(arguments.plaintext, arguments.key, "AES/CBC/PKCS5Padding", "Base64");
    }

    public string function decryptFromStorage(required string ciphertext, required string key) {
        return decrypt(arguments.ciphertext, arguments.key, "AES/CBC/PKCS5Padding", "Base64");
    }

}