import Firebase

struct Message {
    let text, senderID, receiverID : String
    let timestamp: Timestamp
    let isOwnerCurrentUser: Bool
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.senderID = dictionary["senderID"] as? String ?? ""
        self.receiverID = dictionary["receiverID"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isOwnerCurrentUser = Auth.auth().currentUser?.uid == self.senderID
    }
}
