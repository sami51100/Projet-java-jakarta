import org.junit.jupiter.api.*;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class HomePageTest {

    private static WebDriver driver;

    @BeforeAll
    public static void setup() {
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--headless"); // Pas de fenêtre graphique
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");

        driver = new ChromeDriver(options);
    }

    @AfterAll
    public static void teardown() {
        if (driver != null) {
            driver.quit();
        }
    }

    @Test
    public void testHomePageContainsTitle() {
        driver.get("http://10.11.51.242:8080/projet/home");
        String pageSource = driver.getPageSource();
        assertTrue(pageSource.contains("Films Populaires"), "La page d'accueil ne contient pas le mot 'Films Populaires'");
    }
}
