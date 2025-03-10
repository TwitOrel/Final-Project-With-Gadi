import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;

public class WaterMark {
    private static final String WATERMARK_TEXT1 = "Orel Twito 209004092";
    private static final String WATERMARK_TEXT2 = "Elad Huttner 208111740";


    public static void main(String[] args) {
        if (args.length < 1) {
            System.out.println("Usage: java WatermarkApp <directory_path>");
            return;
        }

        File dir = new File(args[0]);
        if (!dir.exists() || !dir.isDirectory()) {
            System.out.println("Invalid directory: " + args[0]);
            return;
        }

        File[] images = dir.listFiles((d, name) -> name.toLowerCase().endsWith(".jpg") || name.toLowerCase().endsWith(".png"));
        if (images == null || images.length == 0) {
            System.out.println("No images found in directory.");
            return;
        }
        File outputDir = new File(args[0] + "/WaterMarkOutput");
        if(!outputDir.exists()){
            outputDir.mkdir();
        }

        for (File image : images) {
            addWatermark(image);
        }

        System.out.println("Watermark added to all images.");
    }

    private static void addWatermark(File imageFile) {
        try {
            BufferedImage image = ImageIO.read(imageFile);
            Graphics2D g2d = (Graphics2D) image.getGraphics();

            // הגדרת שקיפות ואיכות אנטי-אליאסינג
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g2d.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER, 0.5f));

            // הגדרת צבע וגופן
            g2d.setColor(Color.RED);
            g2d.setFont(new Font("Arial", Font.BOLD, image.getWidth() / 15));

            // מיקום הטקסט על התמונה
            int x = image.getWidth() / 10 - 100;
            int y = image.getHeight() - image.getHeight() / 10;

            // הוספת הטקסט על גבי התמונה
            g2d.drawString(WATERMARK_TEXT1, x, y);
            g2d.drawString(WATERMARK_TEXT2, x, y-=300);

            g2d.dispose();

            // שמירת התמונה עם ה-Watermark
            ImageIO.write(image, "png", new File(imageFile.getParent() + "/WaterMarkOutput", "watermarked_" + imageFile.getName()));

            System.out.println("Watermark added to: " + imageFile.getName());
        } catch (Exception e) {
            System.err.println("Error processing file: " + imageFile.getName());
            e.printStackTrace();
        }
    }
}
