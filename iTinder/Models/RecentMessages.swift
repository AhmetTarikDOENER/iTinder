import UIKit
import FirebaseFirestore

struct RecentMessages {
    let text, uid, username, profileImageURL: String
    let timestamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}

