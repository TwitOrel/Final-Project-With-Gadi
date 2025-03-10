import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;

public class Watermark {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Usage: java Watermark <image_path> <text>");
            System.exit(1);
        }

        String imagePath = args[0];
        String watermarkText = args[1];

        try {
            File imageFile = new File(imagePath);
            BufferedImage image = ImageIO.read(imageFile);

            Graphics2D g2d = image.createGraphics();
            g2d.setFont(new Font("Arial", Font.BOLD, 30));
            g2d.setColor(new Color(255, 0, 0, 128));
            g2d.drawString(watermarkText, 10, 50);
            g2d.dispose();

            File output = new File("watermarked_" + imageFile.getName());
            ImageIO.write(image, "png", output);
            System.out.println("Watermark added successfully! Saved as " + output.getName());

        } catch (IOException e) {
            System.out.println("Error processing image: " + e.getMessage());
        }
    }
}
