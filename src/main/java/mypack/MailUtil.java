package mypack;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class MailUtil {
    // SMTP Configuration parameters (configure as needed)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    
    private static final String SMTP_USER = "sapnakumri670@gmail.com"; 
    private static final String SMTP_PASSWORD = "ocuvvfgqypkcbwup";  

    public static boolean sendOTP(String recipientEmail, String otp) {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER, "SkyGlide Airways Team"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Airlines Registration OTP Verification");

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

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean sendTicket(String recipientEmail, String passengerName, String flightNumber, String departure, String arrival, String date, String price, String seatNumber) {
        Properties props = new Properties();
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER, "SkyGlide Airways Team"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("SkyGlide Airways - Booking Confirmation for Flight " + flightNumber);

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

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
