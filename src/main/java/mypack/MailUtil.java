package mypack;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class MailUtil {
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    
    private static String getSmtpUser() {
        String envUser = System.getenv("SMTP_USER");
        return (envUser != null && !envUser.trim().isEmpty()) ? envUser : "sapnakumri670@gmail.com";
    }

    private static String getSmtpPassword() {
        String envPass = System.getenv("SMTP_PASSWORD");
        return (envPass != null && !envPass.trim().isEmpty()) ? envPass : "ocuvvfgqypkcbwup";
    }

    private static boolean sendEmailViaBrevo(String recipientEmail, String recipientName, String subject, String htmlContent) {
        String apiKey = System.getenv("BREVO_API_KEY");
        if (apiKey == null || apiKey.trim().isEmpty()) {
            return false;
        }

        try {
            java.net.URL url = new java.net.URL("https://api.brevo.com/v3/smtp/email");
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("accept", "application/json");
            conn.setRequestProperty("api-key", apiKey);
            conn.setRequestProperty("content-type", "application/json");
            conn.setDoOutput(true);
            conn.setConnectTimeout(5000);
            conn.setReadTimeout(5000);

            // Construct JSON payload securely
            String escapedHtml = htmlContent.replace("\\", "\\\\")
                                            .replace("\"", "\\\"")
                                            .replace("\n", "\\n")
                                            .replace("\r", "");
            String escapedSubject = subject.replace("\"", "\\\"");
            String escapedRecipientName = recipientName != null ? recipientName.replace("\"", "\\\"") : "Valued Customer";

            String payload = "{"
                    + "\"sender\":{"
                    + "  \"name\":\"SkyGlide Airways Team\","
                    + "  \"email\":\"" + getSmtpUser() + "\""
                    + "},"
                    + "\"to\":[{"
                    + "  \"email\":\"" + recipientEmail + "\","
                    + "  \"name\":\"" + escapedRecipientName + "\""
                    + "}],"
                    + "\"subject\":\"" + escapedSubject + "\","
                    + "\"htmlContent\":\"" + escapedHtml + "\""
                    + "}";

            try (java.io.OutputStream os = conn.getOutputStream()) {
                byte[] input = payload.getBytes("utf-8");
                os.write(input, 0, input.length);
            }

            int code = conn.getResponseCode();
            if (code >= 200 && code < 300) {
                System.out.println("Email sent successfully via Brevo HTTP API.");
                return true;
            } else {
                System.err.println("Brevo HTTP API returned code: " + code);
                return false;
            }
        } catch (Exception e) {
            System.err.println("Error sending email via Brevo: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public static boolean sendOTP(String recipientEmail, String otp) {
        String htmlContent = "<div style='font-family: Arial, sans-serif; padding: 20px; max-width: 600px; margin: auto; border: 1px solid #ddd; border-radius: 8px;'>"
                + "<h2 style='color: #6366f1; text-align: center;'>Welcome to Our Airline!</h2>"
                + "<p>Thank you for starting your registration. To verify your email address, please use the following One-Time Password (OTP):</p>"
                + "<div style='text-align: center; margin: 30px 0;'>"
                + "  <span style='background-color: #f3f4f6; color: #6366f1; font-size: 2rem; font-weight: bold; padding: 10px 20px; border-radius: 6px; letter-spacing: 4px; border: 1px dashed #6366f1;'>" + otp + "</span>"
                + "</div>"
                + "<p style='color: #ef4444; font-weight: bold; text-align: center;'>This OTP is valid for 10 minutes. Please do not share it with anyone.</p>"
                + "<hr style='border: none; border-top: 1px solid #eee; margin-top: 30px;'>"
                + "<p style='font-size: 0.8rem; color: #9ca3af; text-align: center;'>This is an automated email. Please do not reply directly.</p>"
                + "</div>";

        // Try Brevo HTTP API first if key exists
        String apiKey = System.getenv("BREVO_API_KEY");
        if (apiKey != null && !apiKey.trim().isEmpty()) {
            boolean isSent = sendEmailViaBrevo(recipientEmail, "Valued Customer", "Airlines Registration OTP Verification", htmlContent);
            if (isSent) {
                return true;
            }
        }

        // Fallback to Gmail SMTP if Brevo fails or is not configured
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.connectiontimeout", "5000"); // 5s connection timeout
        props.put("mail.smtp.timeout", "5000");           // 5s read timeout

        final String smtpUser = getSmtpUser();
        final String smtpPass = getSmtpPassword();

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUser, smtpPass);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(smtpUser, "SkyGlide Airways Team"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Airlines Registration OTP Verification");
            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean sendTicket(String recipientEmail, String passengerName, String flightNumber, String departure, String arrival, String date, String price, String seatNumber) {
        String htmlContent = "<div style='font-family: \"Outfit\", Arial, sans-serif; padding: 25px; max-width: 600px; margin: auto; border: 1px solid #e2e8f0; border-radius: 12px; background-color: #0f172a; color: #f8fafc;'>"
                + "<div style='text-align: center; margin-bottom: 20px;'>"
                + "  <h2 style='color: #6366f1; margin: 0;'>Booking Confirmed!</h2>"
                + "  <p style='color: #94a3b8; font-size: 0.95rem; margin-top: 5px;'>Thank you for choosing SkyGlide Airways. Here is your ticket details:</p>"
                + "</div>"
                + "<div style='background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.08); padding: 20px; border-radius: 8px; margin-bottom: 20px;'>"
                + "  <table style='width: 100%; border-collapse: collapse;'>"
                + "    <tr><td style='padding: 6px 0; color: #94a3b8; font-size: 0.9rem;'>Passenger Name:</td><td style='padding: 6px 0; text-align: right; font-weight: bold; color: #ffffff;'>" + passengerName + "</td></tr>"
                + "    <tr><td style='padding: 6px 0; color: #94a3b8; font-size: 0.9rem;'>Flight Number:</td><td style='padding: 6px 0; text-align: right; font-weight: bold; color: #ffffff;'>Flight #" + flightNumber + "</td></tr>"
                + "    <tr><td style='padding: 6px 0; color: #94a3b8; font-size: 0.9rem;'>Route:</td><td style='padding: 6px 0; text-align: right; font-weight: bold; color: #ffffff;'>" + departure + " &rarr; " + arrival + "</td></tr>"
                + "    <tr><td style='padding: 6px 0; color: #94a3b8; font-size: 0.9rem;'>Departure Date:</td><td style='padding: 6px 0; text-align: right; font-weight: bold; color: #ffffff;'>" + date + "</td></tr>"
                + "    <tr><td style='padding: 6px 0; color: #94a3b8; font-size: 0.9rem;'>Seat Number:</td><td style='padding: 6px 0; text-align: right; font-weight: bold; color: #10b981; font-size: 1.1rem;'>" + seatNumber + "</td></tr>"
                + "    <tr><td style='padding: 6px 0; color: #94a3b8; font-size: 0.9rem;'>Paid Amount:</td><td style='padding: 6px 0; text-align: right; font-weight: bold; color: #f59e0b;'>INR " + price + "</td></tr>"
                + "  </table>"
                + "</div>"
                + "<div style='text-align: center; color: #94a3b8; font-size: 0.85rem;'>"
                + "  <p>You can manage your bookings or download your ticket PDF directly on our dashboard.</p>"
                + "  <p style='margin-top: 15px; font-size: 0.75rem; color: #64748b;'>This is an automated confirmation email. Please do not reply directly to this email.</p>"
                + "</div>"
                + "</div>";

        // Try Brevo HTTP API first if key exists
        String apiKey = System.getenv("BREVO_API_KEY");
        if (apiKey != null && !apiKey.trim().isEmpty()) {
            boolean isSent = sendEmailViaBrevo(recipientEmail, passengerName, "SkyGlide Airways - Booking Confirmation for Flight " + flightNumber, htmlContent);
            if (isSent) {
                return true;
            }
        }

        // Fallback to Gmail SMTP if Brevo fails or is not configured
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        props.put("mail.smtp.connectiontimeout", "5000"); // 5s connection timeout
        props.put("mail.smtp.timeout", "5000");           // 5s read timeout

        final String smtpUser = getSmtpUser();
        final String smtpPass = getSmtpPassword();

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(smtpUser, smtpPass);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(smtpUser, "SkyGlide Airways Team"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("SkyGlide Airways - Booking Confirmation for Flight " + flightNumber);
            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
