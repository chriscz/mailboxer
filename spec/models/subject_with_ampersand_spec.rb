require 'spec_helper'

describe Mailboxer::Message do
  let(:sender) { FactoryGirl.create(:user) }
  let(:recipient) { FactoryGirl.create(:user) }

  before do
    @receipt = sender.send_message(recipient, "This is the message body.", "Test Subject & Special Chars")
    @message = @receipt.notification
  end

  describe "subject line with ampersand" do
    # Subject lines are plain text and must never be HTML-encoded.
    # Encoding is the responsibility of the email API / transport layer.

    it "preserves the ampersand as-is in the subject" do
      expect(@message.subject).to eq("Test Subject & Special Chars")
    end

    it "allows saving a message with an ampersand in the subject" do
      expect(@message).to be_persisted
    end

    it "preserves the ampersand in the conversation subject" do
      receipt = sender.send_message(recipient, "Body of the message", "Subject & Reply")
      expect(receipt.notification.conversation.subject).to eq("Subject & Reply")
    end

    it "preserves the ampersand when replying to a conversation" do
      receipt1 = sender.send_message(recipient, "Body", "Initial Subject & More")
      reply_receipt = sender.reply_to_all(receipt1, "Reply body & more")
      expect(reply_receipt.notification.subject).to eq("Initial Subject & More")
      expect(reply_receipt.notification.conversation.subject).to eq("Initial Subject & More")
    end

    it "preserves multiple ampersands in the subject" do
      multi_amp_subject = "Subject & With & Multiple & Ampersands"
      receipt = sender.send_message(recipient, "Body", multi_amp_subject)
      expect(receipt.notification.subject).to eq(multi_amp_subject)
      expect(receipt.notification.conversation.subject).to eq(multi_amp_subject)
    end

    it "preserves ampersands mixed with other special characters" do
      mixed_subject = "Subject: & Special! (Chars) - Test"
      receipt = sender.send_message(recipient, "Body", mixed_subject)
      expect(receipt.notification.subject).to eq(mixed_subject)
      expect(receipt.notification.conversation.subject).to eq(mixed_subject)
    end

    it "does not double-encode a subject that already contains &amp;" do
      encoded_subject = "Subject &amp; Encoded"
      receipt = sender.send_message(recipient, "Body", encoded_subject)
      expect(receipt.notification.subject).to eq(encoded_subject)
      expect(receipt.notification.conversation.subject).to eq(encoded_subject)
    end
  end
end
