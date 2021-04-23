using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(HotelBooking.Startup))]
namespace HotelBooking
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
