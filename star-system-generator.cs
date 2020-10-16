using System;
using System.Collections.Generic;
using System.IO;

using System.Text.Json;

namespace ConsoleApp1
{
    class Program
    {
        public class Star
        {
            public string star_id { get; set; }
            public int binary_id { get; set; }
            public string star_class { get; set; }
            public double luminosity { get; set; }
            public double radius { get; set; }
            public double mass { get; set; }
            public int temperature { get; set; }
            public string chromaticity { get; set; }
        }

        public class StarSystem
        {
            public int star_system_id { get; set; }
            public List<Star> stars { get; set; }
        }

        public class Galaxy
        {
            public int galaxy_id { get; set; }
            public List<StarSystem> starSystems { get; set; }
        }

        static Star MakeStarProper(Random rand, int current_star_number_id, int total_stars)
        {
            Star s = new Star();
            s.star_id = $"Star_{current_star_number_id}";
            if (total_stars == 2)
                s.binary_id = current_star_number_id;
            s.star_class = "A";
            s.luminosity = Math.Round((rand.NextDouble() * 25), 2);
            s.radius = Math.Round((rand.NextDouble() * 25), 2);
            s.mass = Math.Round((rand.NextDouble() * 5), 2);
            s.temperature = rand.Next(0, 10000);
            s.chromaticity = "Pimp Star";
            return s;
        }

        static void Main(string[] args)
        {
            Random rand = new Random();
            var randomPercentChance = 5;
            var sysCount = 100000;

            Console.WriteLine($"Generating Galaxy with {sysCount} systems!");

            Galaxy galaxy = new Galaxy();
            galaxy.galaxy_id = 1;
            galaxy.starSystems = new List<StarSystem>();

            var watch = System.Diagnostics.Stopwatch.StartNew();

            for (var i = 1; i <= sysCount; i++)
            {
                var total_stars = 1;
                StarSystem starSystem = new StarSystem();
                starSystem.star_system_id = i;
                starSystem.stars = new List<Star>();

                if (rand.Next(0, 100) <= randomPercentChance) {
                    total_stars = 2;
                }

                for (var current_star_number_id = 1; current_star_number_id <= total_stars; current_star_number_id++)
                {
                    var star_rndm = rand.Next(1, 10000);
                    Star star;

                    if (star_rndm <= 7645)
                    {
                        star = MakeStarProper(rand, current_star_number_id, total_stars);
                    }
                    else if (star_rndm <= 8855)
                    {
                        star = MakeStarProper(rand, current_star_number_id, total_stars);
                    }
                    else if (star_rndm <= 9615)
                    {
                        star = MakeStarProper(rand, current_star_number_id, total_stars);
                    }
                    else if (star_rndm <= 9915)
                    {
                        star = MakeStarProper(rand, current_star_number_id, total_stars);
                    }
                    else if (star_rndm <= 9975)
                    {
                        star = MakeStarProper(rand, current_star_number_id, total_stars);
                    }
                    else if (star_rndm <= 9998)
                    {
                        star = MakeStarProper(rand, current_star_number_id, total_stars);
                    }
                    else if (star_rndm <= 10000)
                    {
                        star = MakeStarProper(rand, current_star_number_id, total_stars);
                    }
                    else
                        continue;//default to not trip the below add call with uninitialised variable incase no ifs come true.
                    starSystem.stars.Add(star);
                    //Console.Write(" * ");
                }
                galaxy.starSystems.Add(starSystem);
            }

            Console.WriteLine($"Generation done at {watch.ElapsedMilliseconds} milliseconds!");

            Console.WriteLine($"------------------------------------------------------------");

            Console.WriteLine($"Converting to Json");
            var jsonString = JsonSerializer.Serialize(galaxy);
            Console.WriteLine($"Conversion done at {watch.ElapsedMilliseconds} milliseconds!");

            Console.WriteLine($"------------------------------------------------------------");

            Console.WriteLine($"Writing to Json at c:/tmp/galaxy.json");
            File.WriteAllText(@"c:\tmp\galaxy.json", jsonString);
            Console.WriteLine($"All done {sysCount} at {watch.ElapsedMilliseconds} milliseconds!");
            watch.Stop();

            //Console.WriteLine(jsonString); //make sure its tiny number of systems
            Console.WriteLine("Hit a key to exit motherfucker!");
            Console.Read();
        }
    }
}
