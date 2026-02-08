# Base Interactive Test Case

## Projenin nasıl çalıştırılacağı
1. Repository'i klonlayın:
2. Proje dizinine girin:
3. Bağımlılıkları yükleyin:
4. Uygulamayı çalıştırın:
**Uygulamayı açarken VPN kullanmanız gerekmektedir.**

## Kullanılan mimari veya state yönetimi yaklaşımı 

1- Presentation Katmanı
UI Katmanıdır. UI'lar burada tutulur. 

2- Model Katmanı
MarketItem = UI'da gösterilecek veri kaynağı.
HttpResponseModel = Binance üzerinden gelen veri bu model ile alınır. 
Stream Model = Binance WebSocket'i üzerinden gelen veri bu model ile alınır. 

3- Provider Katmanı
MarketProviders = market verilerini tutmak ve veri işlemlerinin durumunu kontrol etmeye yarar. UI'ın haberdar olduğu tek katman budur. 

4- Repository Katmanı
MarketRepository = HTTP servisini ve Web Socket servisini yönetmeyi sağlar. Provider ile Servis katmanı arasında kalarak soyutlama işlemi yapar. 

5- Servis Katmanı
BinanceHttpService = Http çağrılarının ve hataların kontrolü burada yapılır. 
BinanceWSService = Web Socket bağlantısı ve hataların kontrolü burada yapılır. 

## Varsayımlar veya alınan teknik kararlar
-Http Loading gözükmesi adına splash page kullanıp ilk Binance Http isteği burada yapılmadı, Açılış sayfası Ana Sayfa olarak tasarlandı ve ilk veri çekme işlemi burada yapıldı.
-Uygulama boyunca yalnızca 1 kez Http isteği gönderildi bunun dışındaki tüm veri güncellemeri Web Socket üzerinden yapıldı. 
-WebSocket üzerinden gelen veriler, önceki değerlerle karşılaştırılarak mevcut veri setine yazılır. Örneğin, WebSocket tarafından gönderilen BTCUSDT verisinde volume, lowPrice, highPrice veya lastPrice değerlerinde bir değişiklik yoksa, ilgili item güncellenmez. Değişiklik varsa, yeni değerler nesneye atanır ve priceChange ile priceChangePercent hesaplanarak nesneye eklenir. 
-WebSocket bağlantısında bir error olması durumunda 5 kez tekrar deneyecek şekilde ve her denemede 5 saniye aralık olacak şekilde otomatik olarak tekrar bağlanmayı dener. 5 Deneme sonunda bağlanma başarılı olmazsa Kullanıcıya manuel olarak refresh etmesini sağlayacak bir banner çıkar. 
-Market sayfasında tüm işlemlerin performanslı olması için, her item yalnızca değiştiğinde güncellenir. Bu amaçla Selector kullanılır 



## Uygulamaya ait ekran görüntüleri 

    HOME PAGE
![image alt](https://github.com/ozgurgulacar/Base-Interactive-Test-Case/blob/a893c84448f11ea52812dda2ab729eadd0373d8c/HomePage.jpeg)

    DETAİL PAGE
![image alt](https://github.com/ozgurgulacar/Base-Interactive-Test-Case/blob/a893c84448f11ea52812dda2ab729eadd0373d8c/DetailPage.jpeg)

    HTTP ERROR
![image alt](https://github.com/ozgurgulacar/Base-Interactive-Test-Case/blob/a893c84448f11ea52812dda2ab729eadd0373d8c/httpError.jpeg)

    WEB SOCKET ERROR AUTO RECONNECT (HOME PAGE)
![image alt](https://github.com/ozgurgulacar/Base-Interactive-Test-Case/blob/a893c84448f11ea52812dda2ab729eadd0373d8c/WebSocketErrorAutoReconnect.jpeg)

    WEB SOCKET ERROR AUTO RECONNECT (DETAİL PAGE)
![image alt](https://github.com/ozgurgulacar/Base-Interactive-Test-Case/blob/a893c84448f11ea52812dda2ab729eadd0373d8c/WebSocketErrorAutoReconnectDetailPage.jpeg)

    WEB SOCKET ERROR MANUEL RECONNECT (HOME PAGE)
![image alt](https://github.com/ozgurgulacar/Base-Interactive-Test-Case/blob/a893c84448f11ea52812dda2ab729eadd0373d8c/WebSocketErrorManuelReconnectHomePage.jpeg)

    WEB SOCKET ERROR MANUEL RECONNECT (DETAİL PAGE)
![image alt](https://github.com/ozgurgulacar/Base-Interactive-Test-Case/blob/a893c84448f11ea52812dda2ab729eadd0373d8c/WebSocketErrorManuelReconnectDetailPage.jpeg)

