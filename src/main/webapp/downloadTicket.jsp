<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*"%>
<%@ page import="com.itextpdf.text.*"%>
<%@ page import="com.itextpdf.text.pdf.*"%>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String flightNumber = request.getParameter("flightNumber");
    String price = request.getParameter("price");
    String departure = request.getParameter("departure");
    String arrival = request.getParameter("arrival");
    String seatNumber = request.getParameter("seatNumber");
    String date = request.getParameter("date");

    if (name == null) name = "PASSENGER";
    if (flightNumber == null) flightNumber = "N/A";
    if (price == null) price = "N/A";
    if (departure == null) departure = "N/A";
    if (arrival == null) arrival = "N/A";
    if (seatNumber == null) seatNumber = "1A";
    if (date == null) date = "N/A";

    // Set headers to trigger file download
    response.setContentType("application/pdf");
    response.setHeader("Content-Disposition", "attachment; filename=\"SkyGlide_BoardingPass_" + flightNumber + "_" + seatNumber + ".pdf\"");

    try {
        // Create PDF Document (A6 landscape is typical boarding pass card size)
        Document document = new Document(PageSize.A6.rotate(), 15, 15, 15, 15);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PdfWriter.getInstance(document, baos);

        document.open();

        // Theme colors
        BaseColor primaryColor = new BaseColor(99, 102, 241); // indigo
        BaseColor darkColor = new BaseColor(15, 23, 42); // slate
        BaseColor successColor = new BaseColor(16, 185, 129); // emerald green
        
        Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14, Font.NORMAL, BaseColor.WHITE);
        Font labelFont = FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL, BaseColor.GRAY);
        Font valueFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Font.NORMAL, darkColor);

        // Header Table
        PdfPTable headerTable = new PdfPTable(2);
        headerTable.setWidthPercentage(100);
        headerTable.setWidths(new float[]{70f, 30f});

        PdfPCell titleCell = new PdfPCell(new Paragraph("SKYGLIDE AIRWAYS", titleFont));
        titleCell.setBackgroundColor(darkColor);
        titleCell.setPadding(8);
        titleCell.setBorder(Rectangle.NO_BORDER);
        titleCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        headerTable.addCell(titleCell);

        PdfPCell passTypeCell = new PdfPCell(new Paragraph("BOARDING PASS", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 9, Font.NORMAL, primaryColor)));
        passTypeCell.setBackgroundColor(darkColor);
        passTypeCell.setPadding(8);
        passTypeCell.setBorder(Rectangle.NO_BORDER);
        passTypeCell.setHorizontalAlignment(Element.ALIGN_RIGHT);
        passTypeCell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        headerTable.addCell(passTypeCell);

        document.add(headerTable);

        // Inner Content Table
        PdfPTable contentTable = new PdfPTable(2);
        contentTable.setWidthPercentage(100);
        contentTable.setSpacingBefore(12);

        // Row 1
        PdfPCell nameCell = new PdfPCell();
        nameCell.setBorder(Rectangle.NO_BORDER);
        nameCell.addElement(new Paragraph("PASSENGER NAME", labelFont));
        nameCell.addElement(new Paragraph(name.toUpperCase(), valueFont));
        contentTable.addCell(nameCell);

        PdfPCell flightCell = new PdfPCell();
        flightCell.setBorder(Rectangle.NO_BORDER);
        flightCell.addElement(new Paragraph("FLIGHT NUMBER / SEAT", labelFont));
        flightCell.addElement(new Paragraph("Flight " + flightNumber + " / Seat " + seatNumber, valueFont));
        contentTable.addCell(flightCell);

        // Row 2
        PdfPCell routeCell = new PdfPCell();
        routeCell.setBorder(Rectangle.NO_BORDER);
        routeCell.setPaddingTop(8);
        routeCell.addElement(new Paragraph("ROUTE (FROM -> TO)", labelFont));
        routeCell.addElement(new Paragraph(departure.toUpperCase() + " -> " + arrival.toUpperCase(), valueFont));
        contentTable.addCell(routeCell);

        PdfPCell dateCell = new PdfPCell();
        dateCell.setBorder(Rectangle.NO_BORDER);
        dateCell.setPaddingTop(8);
        dateCell.addElement(new Paragraph("DEPARTURE DATE / TIME", labelFont));
        dateCell.addElement(new Paragraph(date, valueFont));
        contentTable.addCell(dateCell);

        // Row 3
        PdfPCell priceCell = new PdfPCell();
        priceCell.setBorder(Rectangle.NO_BORDER);
        priceCell.setPaddingTop(8);
        priceCell.addElement(new Paragraph("TOTAL AMOUNT PAID", labelFont));
        priceCell.addElement(new Paragraph("INR " + price, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Font.NORMAL, primaryColor)));
        contentTable.addCell(priceCell);

        PdfPCell statusCell = new PdfPCell();
        statusCell.setBorder(Rectangle.NO_BORDER);
        statusCell.setPaddingTop(8);
        statusCell.addElement(new Paragraph("TICKET STATUS", labelFont));
        statusCell.addElement(new Paragraph("PAID / CONFIRMED", FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10, Font.NORMAL, successColor)));
        contentTable.addCell(statusCell);

        document.add(contentTable);

        // Footer Barcode
        PdfPTable barcodeTable = new PdfPTable(1);
        barcodeTable.setWidthPercentage(100);
        barcodeTable.setSpacingBefore(15);

        String alphaNumeric = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sbPnr = new StringBuilder();
        java.util.Random randPnr = new java.util.Random();
        for (int i = 0; i < 4; i++) {
            sbPnr.append(alphaNumeric.charAt(randPnr.nextInt(alphaNumeric.length())));
        }
        String randomPnr = "SG" + sbPnr.toString();
        PdfPCell barcodeCell = new PdfPCell();
        barcodeCell.setBorder(Rectangle.NO_BORDER);
        barcodeCell.setHorizontalAlignment(Element.ALIGN_CENTER);
        
        Paragraph barcode = new Paragraph("||||| || |||| ||| || |||| ||||| ||| ||| ||| ||| |||", FontFactory.getFont(FontFactory.COURIER, 11, Font.NORMAL, darkColor));
        barcode.setAlignment(Element.ALIGN_CENTER);
        barcodeCell.addElement(barcode);

        Paragraph pnrRef = new Paragraph("PNR: " + randomPnr, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 7, Font.NORMAL, darkColor));
        pnrRef.setAlignment(Element.ALIGN_CENTER);
        barcodeCell.addElement(pnrRef);

        barcodeTable.addCell(barcodeCell);
        document.add(barcodeTable);

        document.close();

        // Write the PDF stream to client
        OutputStream os = response.getOutputStream();
        baos.writeTo(os);
        os.flush();
        os.close();
    } catch (DocumentException e) {
        e.printStackTrace();
    }
%>
