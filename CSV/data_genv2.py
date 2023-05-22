import csv
import random
from datetime import date, timedelta
from faker import Faker

fake = Faker()

# Constants
num_users = 100
num_places = 30
num_concerts = 50
num_playlists = 50
num_music = 200
num_posts = 100
num_reviews = 100
num_comments = 200
num_tags = 7
num_actions = 200
num_user_page = 100
num_events = 20
num_groups = 20
num_parent_child_tags = 2
num_concert_hall_tags = 5
num_event_tags = 5
num_playlist_tags = 5
num_comment_tags = 5

concert_hall_tag_ids = list(range(1, num_concert_hall_tags + 1))
event_tag_ids = list(range(1, num_event_tags + 1))
playlist_tag_ids = list(range(1, num_playlist_tags + 1))
comment_tag_ids = list(range(1, num_comment_tags + 1))
tag_ids = list(range(1, num_tags + 1))
event_ids = list(range(1, num_events + 1))
user_ids = list(range(1, num_users + 1))
place_ids = list(range(1, num_places + 1))
concert_ids = list(range(1, num_concerts + 1))
playlist_ids = list(range(1, num_playlists + 1))
music_ids = list(range(1, num_music + 1))
post_ids = list(range(1, num_posts + 1))
review_ids = list(range(1, num_reviews + 1))
comment_ids = list(range(1, num_comments + 1))
tag_ids = list(range(1, num_tags + 1))
action_ids = list(range(1, num_actions + 1))
user_page_ids = list(range(1, num_user_page + 1))

unique_names = set()
parent_child_tag_ids = list(range(1, num_parent_child_tags + 1))


notes = [1, 2, 3, 4, 5]


genres = ['Rock', 'Pop', 'Hip Hop', 'Jazz', 'Classical', 'Country', 'Electronic']
sub_genres = ['Alternative Rock', 'Pop Rock', 'Trap', 'Smooth Jazz', 'Baroque', 'Bluegrass', 'Ambient']

# user
with open('CSV/user.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for _ in range(num_users):
        name = fake.name()
        while name in unique_names:  # Ensuring unique names
            name = fake.name()
        unique_names.add(name)
        writer.writerow([name])

# follow and friendship
with open('CSV/follow.csv', 'w', newline='') as file, open('CSV/friendship.csv', 'w', newline='') as file2:
    writer1 = csv.writer(file)
    writer2 = csv.writer(file2)
    writer1.writerow(["SKIP"])
    writer2.writerow(["SKIP"])
    for i in range(1, num_users + 1):
        # let each user follow and befriend the next user, with ids wrapping around at the end
        writer1.writerow([i, i % num_users + 1])
        writer2.writerow([i, i % num_users + 1])

# event, group, person, place, and concertHall
with open('CSV/event.csv', 'w', newline='') as file, open('CSV/group.csv', 'w', newline='') as file2, open('CSV/person.csv', 'w', newline='') as file3, open('CSV/place.csv', 'w', newline='') as file4, open('CSV/concertHall.csv', 'w', newline='') as file5:
    writer1 = csv.writer(file)
    writer2 = csv.writer(file2)
    writer3 = csv.writer(file3)
    writer4 = csv.writer(file4)
    writer5 = csv.writer(file5)
    writer1.writerow(["SKIP"])
    writer2.writerow(["SKIP"])
    writer3.writerow(["SKIP"])
    writer4.writerow(["SKIP"])
    writer5.writerow(["SKIP"])
    for i in range(1, num_users + 1):
        writer1.writerow([i])
        writer2.writerow([i])
        writer3.writerow([i])
        writer4.writerow([i, fake.address().replace("\n", ", ")])
        if i <= num_places:  # Creating only 'num_places' concert halls
            writer5.writerow([i, fake.company()])

# associations, user_page
with open('CSV/associations.csv', 'w', newline='') as file:
    writer1 = csv.writer(file)
    writer1.writerow(["SKIP"])
    for i in range(1, num_users + 1):
        writer1.writerow([i])

# music
with open('CSV/music.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for i in music_ids:
        writer.writerow([i, random.choice(user_ids), fake.bs()])

# post, review
with open('CSV/post.csv', 'w', newline='') as file1, open('CSV/review.csv', 'w', newline='') as file2:
    writer1 = csv.writer(file1)
    writer2 = csv.writer(file2)
    writer1.writerow(["SKIP"])
    writer2.writerow(["SKIP"])

    current_date = date.today()
    for i in range(1, num_posts + 1):
        post_date = current_date - timedelta(days=i)  # Decrementing date for each post
        writer1.writerow([i, random.choice(user_ids), random.choice(concert_ids), fake.text(), post_date])

    for i in range(1, num_reviews + 1):
        review_date = current_date - timedelta(days=i)  # Decrementing date for each review
        writer2.writerow([i, random.choice(notes), random.choice(user_ids), random.choice(event_ids)])

# comment
with open('CSV/comment.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for i in comment_ids:
        writer.writerow([fake.text(), random.choice(review_ids)])

# action
with open('CSV/action.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    actions = ['Interesse', 'Participe']
    for i in action_ids:
        writer.writerow([i, random.choice(actions), random.choice(user_ids), random.choice(concert_ids)])

# tags
with open('CSV/tag.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    genres = ['Rock', 'Pop', 'Hip Hop', 'Jazz', 'Classical', 'Country', 'Electronic']
    sub_genres = ['Alternative Rock', 'Pop Rock', 'Trap', 'Smooth Jazz', 'Baroque', 'Bluegrass', 'Ambient']
    d = set()
    for i in range(1, num_tags + 1):
        writer.writerow([genres[i - 1], False])

# user_page
with open('CSV/user_page.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for i in range(1, num_user_page + 1):
        writer.writerow([i, random.randint(1, num_users)])

# playlist
with open('CSV/playlist.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for i in range(1, num_playlists + 1):
        writer.writerow([i, random.randint(1, num_users), fake.bs(), random.randint(1, num_user_page)])

# concert
with open('CSV/concert.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for i in concert_ids:
        price = random.randint(10, 100)
        organizers = random.choice(user_ids)
        lineup = random.choice(user_ids)
        place = random.choice(place_ids)
        supporting_cause = fake.text(max_nb_chars=200)
        outdoor_space = random.choice([True, False])
        child_allowed = random.choice([True, False])
        current_date = date.today()
        writer.writerow([i, organizers, lineup, place, price, supporting_cause, outdoor_space, child_allowed, current_date])

# music_notes
with open('CSV/music_notes.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for _ in range(num_music):
        writer.writerow([random.choice(music_ids), random.choice(user_ids), random.randint(1, 5)])

# playlist_music
with open('CSV/playlist_music.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    d = set()
    for _ in range(num_music):
        a, b = random.choice(playlist_ids), random.choice(music_ids)
        if (a,b) not in d:
            writer.writerow([a, b])
            d.add((a, b))

# page_playlist
with open('CSV/page_playlist.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for i in range(num_user_page):
        for j in random.sample(playlist_ids, 10):  # Each page can have a maximum of 10 playlists
            writer.writerow([i + 1, j])

past_concert_ids = set()
# pastConcert
with open('CSV/pastConcert.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    d = set()
    for _ in range(num_concerts // 2):  # Assuming half of the concerts are in the past
        n = random.choice(concert_ids)
        if n not in d:
            writer.writerow([n, random.randint(10, 100)])
            d.add(n)
    past_concert_ids = d

# pastConcertMedia
with open('CSV/pastConcertMedia.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for i in past_concert_ids:
        writer.writerow([i, fake.file_path(depth=2, extension='jpg')])

# futureConcert
with open('CSV/futureConcert.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for i in range(num_concerts // 2, num_concerts):  # Assuming the other half are future concerts
        writer.writerow([i + 1, random.choice([True, False]), random.randint(10, 100), random.randint(20, 200)])

# concert_hall_tags
with open('CSV/concert_hall_tags.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for i in concert_hall_tag_ids:
        writer.writerow([random.choice(place_ids), random.choice(genres)])

# event_tags
with open('CSV/event_tags.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    d = set()
    for i in event_tag_ids:
        n = random.choice(event_ids)
        if n not in d:
            writer.writerow([n, random.choice(genres)])
            d.add(n)

# playlist_tags
with open('CSV/playlist_tags.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    s = set()
    for i in playlist_tag_ids:
        writer.writerow([random.choice(playlist_ids), random.choice(genres)])

# commentTag
with open('CSV/commentTag.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for i in comment_tag_ids:
        writer.writerow([random.choice(comment_ids), random.choice(genres)])

with open('CSV/parent_child_tags.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["SKIP"])
    for _ in range(num_parent_child_tags):
        parent_tag = random.choice(genres)
        child_tag = random.choice(genres)
        writer.writerow([parent_tag, child_tag])