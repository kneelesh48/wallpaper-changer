const fetch = require('node-fetch');

const wallpaper_subs = [
    ['EarthPorn', 20820398],
    ['NatureIsFuckingLit', 4541833],
    ['wallpaper', 1617000],
    //  ['SpacePorn', 1391019],
    ['CityPorn', 658981],
    ['wallpapers', 605178],
    ['SkyPorn', 179753],
    //  ['BotanicalPorn', 141254],
    //  ['WaterPorn', 96425],
    //  ['VillagePorn', 73553],
    ['BeachPorn', 56079],
    ['WeatherPorn', 50865],
    //  ['multiwall', 27388],
    //  ['LakePorn', 7427]
]

function rand_num(n) {
    return Math.floor(Math.random() * n)
}

// let filename, img_url, sub, title;
let data_needed = 0;

async function wallpaper_changer() {
    break_loop = false;
    for (let j = 0; j < 5; j++) {
        if (break_loop) { break }
        sub = wallpaper_subs[rand_num(wallpaper_subs.length)][0]
        console.log(`Subreddit: ${sub}`)
        let response = await fetch(`https://reddit.com/r/${sub}/top.json?t=day&limit=5`)
        let data = await response.json()
        returned_len = data.data.children.length
        console.log(`Results returned: ${returned_len}`)
        n = rand_num(returned_len)
        for (let i = 0; i < returned_len; i++) {
            submission = data.data.children[(n + i) % returned_len]
                //             console.log(submission.data.permalink)
            img_url = submission.data.url
            console.log(img_url)
            split_url = img_url.split('/')
            filename = split_url[split_url.length - 1]
            if (submission.data.post_hint !== 'image') { //submission is image
                console.log('File not image')
                continue
            }
            if (img_url.slice(-3) === 'gif') { //submission is not gif
                console.log('File is gif')
                continue
            }
            width = submission.data.preview.images[0].source.width
            height = submission.data.preview.images[0].source.height
            if (width > height) { //image must be vertical
                console.log('Image must be horizontal')
                continue
            }
            if (!(width >= 1280 && height >= 720)) { //image res>720p
                console.log('Image low res')
                continue
            }
            title = submission.data.title
                // download file here
                // console.log(title)
                //             break_loop = true
                //             break
            data_needed = [filename, img_url, sub, title]
            return
        }
    }
}
async function main() {
    // data_needed = await wallpaper_changer()
    await wallpaper_changer()
    console.log(data_needed)
}
main()